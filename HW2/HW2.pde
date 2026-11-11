Engine engine;

void setup() {
    size(1000, 600);
    engine = new Engine();
}

void draw() {
    background(255);

    engine.run();

}

void keyPressed() {
    if (key == 'a' || key == 'A') {
        engine.shapeRenderer.useSSAA = !engine.shapeRenderer.useSSAA;
    }
}
