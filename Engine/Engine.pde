import processing.net.*;

static final float FRAME_RATE = 60;

static final float GRAVITY = 0.2;
static final float JUMPING_FORCE = 7.5;

static final float PIPE_CREATE_TIME_MILLIS = 3000;
static final float PIPE_MIN_HEIGHT = 100;
static final float PIPE_WIDTH = 25;
static final float PASS_AREA_HEIGHT = 100;

Bird bird;
PipeManager pipes;

void setup() {
	size(800, 800); // 800 x 800 Window Size
	frameRate(FRAME_RATE); // Default

	bird = new Bird(800, 800, GRAVITY, JUMPING_FORCE);
	pipes = new PipeManager(800, 800, PIPE_MIN_HEIGHT, PIPE_WIDTH, PASS_AREA_HEIGHT, PIPE_CREATE_TIME_MILLIS);
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
	float maxWidth, maxHeight;
	float gravity, jumpingForce;

	float x, y, speed;
	boolean isJumping;

	public Bird(float maxWidth, float maxHeight, float gravity, float jumpingForce) {
		this.maxWidth = maxWidth;
		this.maxHeight = maxHeight;

		this.gravity = gravity;
		this.jumpingForce = jumpingForce;

		x = maxWidth / 4;
		y = maxHeight / 2;
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
	float maxWidth, maxHeight;
	float minPipeHeight, pipeWidth, passAreaHeight, pipeCreateTimeMillis;
	float lastObstalceCreateMs;

	ArrayList<Pipe> pipes;

	public PipeManager(float maxWidth, float maxHeight, float minPipeHeight, float pipeWidth, float passAreaHeight, float pipeCreateTimeMillis) {
		this.maxWidth = maxWidth;
		this.maxHeight = maxHeight;

		this.minPipeHeight = minPipeHeight;
		this.pipeWidth = pipeWidth;
		this.passAreaHeight = passAreaHeight;
		this.pipeCreateTimeMillis = pipeCreateTimeMillis;

		lastObstalceCreateMs = 0F;
		pipes = new ArrayList<Pipe>();
	}

	public boolean loop() {
		float curMillis = millis();
		boolean created =  false;

		if (curMillis > lastObstalceCreateMs + pipeCreateTimeMillis) {
			createPipe();
			lastObstalceCreateMs = curMillis;
			created = true;
		}

		for (int i = 0; i < pipes.size(); i++) {
			Pipe pipe = pipes.get(i);
			if (pipe.getX() < 0) pipes.remove(i--);
			else pipe.loop();
		}

		return created;
	}

	private void createPipe() {
		System.out.println("Create Pipe!!");
		float topHeight = random(minPipeHeight, maxHeight - (minPipeHeight + passAreaHeight));
		float bottomHeight = maxHeight - (topHeight + passAreaHeight);

		Pipe pipe = new Pipe(0, topHeight, maxWidth - bottomHeight, bottomHeight, maxWidth - 100, pipeWidth);
		pipes.add(pipe);
	}
}

class Pipe {
	float topY, topHeight;
	float bottomY, bottomHeight;
	float x, width;

	public Pipe(float topY, float topHeight, float bottomY, float bottomHeight, float x, float width) {
		setPipe(topY, topHeight, bottomY, bottomHeight, x, width);
	}

	public void loop() {
		rect(x, topY, width, topHeight);
		rect(x, bottomY, width, bottomHeight);
		x -= 1;
	}

	public void setPipe(float topY, float topHeight, float bottomY, float bottomHeight, 
						float x, float width) {
		this.topY = topY;
		this.topHeight = topHeight;

		this.bottomY = bottomY;
		this.bottomHeight = bottomHeight;

		this.x = x;
		this.width = width;
	}

	public float getX() {
		return this.x;
	}
}
