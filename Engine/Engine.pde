import processing.net.*;

static final float MAX_WIDTH = 800;
static final float MAX_HEIGHT = 800;
static final float FRAME_RATE = 60; // Default

Bird bird;
PipeManager pipeManager;

int previousPoint;

boolean keyInputed;
boolean isGameOver;

// TODO: show point (ML agent fitness)
void setup() {
	size(800, 800);
	frameRate(FRAME_RATE);
	smooth();
	noStroke();

	bird = new Bird(MAX_WIDTH, MAX_HEIGHT);
	pipeManager = new PipeManager(MAX_WIDTH, MAX_HEIGHT, bird);

	previousPoint = 0;

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
	if (!keyInputed && !isGameOver && key == ENTER) bird.jump();
	keyInputed = true;
}

void keyReleased() {
	keyInputed = false;
}

void showPoint() {
	int point;
	if (isGameOver) point = previousPoint;
	else point = 0;

	fill(0, 0, 0);
	textSize(min(MAX_WIDTH, MAX_HEIGHT) / 32);
	textAlign(CENTER, CENTER);
	text(str(int(point)), MAX_WIDTH / 2, MAX_HEIGHT / 4);
	fill(255, 255, 255);

	previousPoint = point;
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
	 return datas;
}
