#include <iostream>
#include <queue>
#include <list>

#include <SFML/Graphics.hpp>

class ShadeyApp
{
    enum class Action
    {
        NONE,
        CLOSE_WINDOW,
    };

    std::queue<Action> requested_actions;

    sf::RenderWindow window;
    sf::Shader shader;
    std::list<sf::Drawable *> drawables;
    std::list<sf::Texture *> textures;

    bool running;

    sf::Clock clock;

public:
    ShadeyApp() : running{true} {}

    ~ShadeyApp()
    {
        for (auto drawable : drawables)
            delete drawable;
        drawables.clear();

        for (auto texture : textures)
            delete texture;
        textures.clear();
    }

    int main()
    {
        if (!sf::Shader::isAvailable())
        {
            std::cerr << "you need to upgrade your graphics card to use this fantastic bit of software." << std::endl;
            return EXIT_FAILURE;
        }

        // do this early to catch compile errors before spending time in windowing code
        if (!shader.loadFromFile("shaders/frag.glsl", sf::Shader::Type::Fragment))
            return EXIT_FAILURE;

        auto scale = 10u;
        sf::VideoMode vidmode{160 * scale, 120 * scale, 8};
        window.create(vidmode, "shadey", sf::Style::Close);

        sf::Texture tex{};
        if (!tex.loadFromFile("res/noise.png"))
            return EXIT_FAILURE;
        tex.setRepeated(true);
        tex.setSmooth(false);

        auto canvas = new sf::Sprite{};
        canvas->setTexture(tex);
        canvas->setScale(scale, scale);
        drawables.push_back(canvas);

        shader.setUniform("texture", sf::Shader::CurrentTexture);

        while (running)
        {
            process_actions();
            event_loop();
            update();
            draw();
        }

        window.close();

        return EXIT_SUCCESS;
    }

    void process_actions()
    {
        while (!requested_actions.empty())
        {
            auto action = requested_actions.front();
            switch (action)
            {
            case Action::CLOSE_WINDOW:
                running = false;
                break;
            default:
                break;
            }
            requested_actions.pop();
        }
    }

    void event_loop()
    {
        sf::Event ev;
        while (window.pollEvent(ev))
        {
            switch (ev.type)
            {
            case sf::Event::Closed:
                requested_actions.emplace(Action::CLOSE_WINDOW);
                break;
            default:
                break;
            }
        }
    }

    void update()
    {
        shader.setUniform("time", clock.getElapsedTime().asSeconds());
    }

    void draw()
    {
        window.clear();
        for (auto drawable : drawables)
            window.draw(*drawable, &shader);
        window.display();
    }
};

int main()
{
    return ShadeyApp().main();
}
