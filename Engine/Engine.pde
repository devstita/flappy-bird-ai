import processing.net.*;

static final float MAX_WIDTH = 800;
static final float MAX_HEIGHT = 800;
static final float FRAME_RATE = 60; // Default

Bird bird;
PipeManager pipeManager;

int point;

boolean keyInputed;
boolean isGameOver;

void setup() {
	size(800, 800);
	frameRate(FRAME_RATE);
	smooth();
	noStroke();

	bird = new Bird(MAX_WIDTH, MAX_HEIGHT);
	pipeManager = new PipeManager(MAX_WIDTH, MAX_HEIGHT, bird);

	point = 0;

	keyInputed = false;
	isGameOver = false;
}

void draw() {
	background(135, 206, 235);

	pipeManager.loop();
	bird.loop();
	showPoint();

	if (isGameOver) gameOver();
}

void keyPressed() {
	if (!keyInputed && !isGameOver)
		if (key == ' ' || key == ENTER || (key == CODED && keyCode == UP)) bird.jump();
	keyInputed = true;
}

void keyReleased() {
	keyInputed = false;
}

void showPoint() {
	fill(0, 0, 0);
	textSize(min(MAX_WIDTH, MAX_HEIGHT) / 24);
	textAlign(CENTER, CENTER);
	text(str(int(point)), MAX_WIDTH / 2, MAX_HEIGHT / 8);
	fill(255, 255, 255);
}

void pipePassed() {
	point++;
}

void gameOver() {
	isGameOver = true;
	bird.disable();
	pipeManager.disable();

	fill(0, 0, 0);
	textSize(min(MAX_WIDTH, MAX_HEIGHT) / 8);
	textAlign(CENTER, CENTER);
	text("GAME OVER", MAX_WIDTH / 2, MAX_HEIGHT / 2);
	fill(255, 255, 255);
}

// TODO: Develop get data algorithm

	// TODO: Re-Check Data
// ML - Fitness: Time millis after running game
IntList getDataForML(Bird bird, PipeManager pipeManager) {
	IntList datas = new IntList();
	
	/*
	 * datas.size() = 8
	 * datas.get(0) = bird distance from bottom (y)
	 * datas.get(1) = bird distance from nearest front (x)
	 * datas.get(2) = bird distance from top start position of pass area (x)
	 * datas.get(3) = bird distance from top end position of pass area (x)
	 * datas.get(4) = bird distance from bottom end position of pass area (x)
	 * datas.get(5) = bird distance from bottom end position of pass area (x)
	 * datas.get(6) = bird distance from top position of pass area (y)
	 * datas.get(7) = bird distance from bottom position of pass area (y)
	 */

	Pipe nearestPipe = pipeManager.getNearestFrontPipe();

	 return datas;
}
