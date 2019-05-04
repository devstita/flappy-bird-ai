import processing.net.*;

static final float MAX_WIDTH = 800;
static final float MAX_HEIGHT = 800;
static final float FRAME_RATE = 60; // Default

static final String SERVER_IP = "127.0.0.1";
static final int PORT = 9857;

// TODO: Clone bird for Genetic Algorithm
Bird bird;
PipeManager pipeManager;

int point;

boolean keyInputed;
boolean isGameOver;

SerialConnection sc;

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

	sc = new SerialConnection(SERVER_IP, PORT);
}

void draw() {
	background(135, 206, 235);

	pipeManager.loop();
	bird.loop();
	showPoint();

	if (isGameOver) {
		gameOver();
		return;
	}

	sc.sendData(getDataForML(bird, pipeManager));
	act(sc.loop());
}

void keyPressed() {
	if (!keyInputed && !isGameOver)
		if (key == ' ' || key == ENTER || (key == CODED && keyCode == UP)) bird.jump();
	keyInputed = true;
}

void keyReleased() {
	keyInputed = false;
}

// FIXME: Solve Making Exception when socket is disactived algorithm
void stop() {
	log("Stoped");
	sc.disconnect();
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

void act(int action) {
	log(action);
	switch (action) {
		default:
		case 0: 
			// Do Nothing
			break;
		case 1: 
			bird.jump();
			break;
	}
}

FloatList getDataForML(Bird bird, PipeManager pipeManager) {
	FloatList datas = new FloatList();

	/*
	 * datas.size() = 7
	 * datas.get(0) = point // This data will be used when the genetic algorithm run
	 * datas.get(1) = daed (0) or alive (1)
	 * datas.get(2) = bird distance from bottom (y)
	 * 
	 * datas.get(3) = bird distance from nearest front pipe start (x) -> (-1) = passed
	 * datas.get(4) = bird distance from nearest front pipe end (x) -> (-1) = passed
	 * datas.get(5) = bird distance from top position of pass area (y)
	 * datas.get(6) = bird distance from bottom position of pass area (y)
	 */

	Pipe nearestPipe = pipeManager.getNearestFrontPipe();

	// TODO: Check what to use for reward (variable)
	datas.append(float(point)); // 0
	datas.append(float(int(!isGameOver))); // 1
	datas.append((MAX_HEIGHT - bird.getYUnderBird() < 0) ? 0 : MAX_HEIGHT - bird.getYUnderBird()); // 2
	datas.append((nearestPipe.getXLeftPipe() - bird.getXRightBird() < 0) ? -1 : nearestPipe.getXLeftPipe() - bird.getXRightBird()); // 3
	datas.append((nearestPipe.getXRightPipe() - bird.getXLeftBird() < 0) ? -1 : nearestPipe.getXRightPipe() - bird.getXLeftBird()); // 4
	datas.append(bird.getYUpperBird() - nearestPipe.getTopYUnderPipe()); // 5
	datas.append(nearestPipe.getBottomYUpperPipe() - bird.getYUnderBird()); // 6
	
	// for (int i = 0; i < datas.size(); i++) print(datas.get(i) + ", ");
	// newLine();

	return datas;
}

void log(String str) {
	println(str);
}

void error(String str) {
	println("[ ERROR ] " + str);
	exit();
	stop();
}

void newLine() {
	println();
}
