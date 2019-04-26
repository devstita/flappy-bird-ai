import processing.net.*;

final float FRAME_RATE = 60;

final float GRAVITY = 0.2;
final float JUMPING_FORCE = 7.5;

final float PIPE_CREATE_TIME_MILLIS = 3000;
final float PIPE_MIN_HEIGHT = 100;
final float PIPE_WIDTH = 25;
final float PASS_AREA_HEIGHT = 100;

Bird bird;
PipeManager pipes;

void setup() {
	size(800, 800); // 800 x 800 Window Size
	frameRate(FRAME_RATE); // Default

	bird = new Bird(GRAVITY, JUMPING_FORCE);
	pipes = new PipeManager(PIPE_MIN_HEIGHT, PIPE_WIDTH, PASS_AREA_HEIGHT, PIPE_CREATE_TIME_MILLIS);
}

void draw() {
	background(135, 206, 235);

	pipes.loop();
	bird.loop();
}

void keyReleased() {
	if (key == ENTER) bird.jump();
}

class Bird {
	float gravity, jumpingForce;

	float x, y, speed;
	boolean isJumping;

	public Bird(float gravity, float jumpingForce) {
		this.gravity = gravity;
		this.jumpingForce = jumpingForce;

		x = MAX_WIDTH / 4;
		y = MAX_HEIGHT / 2;
		speed = gravity;
		isJumping = false;
	}

	public void loop() {
		ellipse(x, y, 50, 50);

		if (!isJumping) {
			y += speed;
			speed += gravity;
		} else {
			if (speed <= 0) {
				isJumping = false;
				speed = 0;
			}

			y -= speed;
			speed -= gravity;
		}
	}

	public void jump() {
		isJumping = true;
		speed = jumpingForce;
	}
}

class PipeManager {
	float minPipeHeight, pipeWidth, passAreaHeight, pipeCreateTimeMillis;
	float lastObstalceCreateMs;

	public PipeManager(float minPipeHeight, float pipeWidth, float passAreaHeight, float pipeCreateTimeMillis) {
		this.minPipeHeight = minPipeHeight;
		this.pipeWidth = pipeWidth;
		this.passAreaHeight = passAreaHeight;
		this.pipeCreateTimeMillis = pipeCreateTimeMillis;

		lastObstalceCreateMs = 0F;
	}

	public boolean loop() {
		float curMillis = millis();

		if (curMillis > lastObstalceCreateMs + pipeCreateTimeMillis) {
			createPipe();
			lastObstalceCreateMs = curMillis;
			return true;
		} else return false;
	}

	private void createPipe() {
		System.out.println("Create Pipe!!");
		float topHeight = random(minPipeHeight, MAX_HEIGHT - (minPipeHeight + passAreaHeight));
		float bottomHeight = MAX_HEIGHT - (topHeight + passAreaHeight);

		Pipe pipe = new Pipe(this, MAX_WIDTH - 100, 0, topHeight, MAX_WIDTH - 100, MAX_HEIGHT - bottomHeight, bottomHeight, pipeWidth);
	}
}

class Pipe {
	PipeManager manager;

	float topX, topY, topHeight;
	float bottomX, bottomY, bottomHeight;
	float width;

	public Pipe(PipeManager manager) {
		this.manager = manager;
	}

	public Pipe(PipeManager manager, float topX, float topY, float topHeight
								, float bottomX, float bottomY, float bottomHeight, float width) {
		this.manager = manager;
		setPosition(topX, topY, topHeight, bottomX, bottomY, bottomHeight);
	}

	public void setPipe(float topX, float topY, float topHeight
								, float bottomX, float bottomY, float bottomHeight, float width) {
		this.topX = topX;
		this.topY = topY;
		this.topHeight = topHeight;

		this.bottomX = bottomX;
		this.bottomY = bottomY;
		this.bottomHeight = bottomHeight;

		this.width = width;
	}

	public void loop() {
		rect(topX, topY, width, topHeight);
		rect(bottomX, bottomY, width, bottomHeight);
	}
}
