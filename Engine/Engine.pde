import processing.net.*;

static final float MAX_WIDTH = 1200;
static final float MAX_HEIGHT = 800;
static final float FRAME_RATE = 60; // Default

Bird bird;
PipeManager pipeManager;

boolean isGameOver;

void setup() {
	size(1200, 800);
	frameRate(FRAME_RATE);
	smooth();
	noStroke();

	bird = new Bird(MAX_WIDTH, MAX_HEIGHT);
	pipeManager = new PipeManager(MAX_WIDTH, MAX_HEIGHT, bird);

	isGameOver = false;
}

void draw() {
	background(135, 206, 235);

	pipeManager.loop();
	bird.loop();

	if (isGameOver) gameOver();
}

void keyPressed() {
	if (!isGameOver) {
		if (key == ENTER) bird.jump();
	}
}

void gameOver() {
	System.out.println("Game Over");
	isGameOver = true;
	bird.disable();
	pipeManager.disable();
	// noLoop();

	textSize(min(MAX_WIDTH, MAX_HEIGHT) / 8);
	textAlign(CENTER, CENTER);
	text("GAME OVER", MAX_WIDTH / 2, MAX_HEIGHT / 2);
}

class Bird {
	private static final float GRAVITY = 0.5F;
	private static final float JUMPING_FORCE = 7.0F;
	private static final float BIRD_SIZE = 40F;

	float maxWidth, maxHeight;

	float x, y, speed;
	boolean isDisabled, isJumping;

	public Bird(float maxWidth, float maxHeight) {
		this.maxWidth = maxWidth;
		this.maxHeight = maxHeight;

		x = maxWidth / 4;
		y = maxHeight / 2;
		speed = GRAVITY;

		isDisabled = false;
		isJumping = false;
	}

	public void loop() {
		ellipse(x, y, BIRD_SIZE, BIRD_SIZE);

		if (getYWithoutSize() >= 800) gameOver();

		if (!isDisabled) {
			if (!isJumping) {
				y += speed;
				speed += GRAVITY;
			} else {
				if (speed <= 0) {
					isJumping = false;
					speed = 0;
				}

				y -= speed;
				speed -= GRAVITY;
			}
		}
	}

	public void jump() {
		System.out.println("Jump Bird!!");
		isJumping = true;
		speed = JUMPING_FORCE;
	}

	private float getYWithoutSize() {
		return (this.y + BIRD_SIZE / 2);
	}

	public void disable() {
		this.isDisabled = true;
	}
}

// TODO: Develop Collision Check Algorithm
// FIXME: Flashing pipe error
class PipeManager {
	private static final float PIPE_CREATE_TIME_MILLIS = 4500;
	private static final float PIPE_MIN_HEIGHT = 100;
	private static final float PIPE_WIDTH = 75;
	private static final float PASS_AREA_HEIGHT = 150;

	float maxWidth, maxHeight;
	Bird bird;

	float lastObstalceCreateMs;
	float movingSpeed;
	boolean isDisabled;

	ArrayList<Pipe> pipes;

	public PipeManager(float maxWidth, float maxHeight, Bird bird) {
		this.maxWidth = maxWidth;
		this.maxHeight = maxHeight;
		this.bird = bird;

		lastObstalceCreateMs = 0F;
		movingSpeed = 1;
		isDisabled = false;

		pipes = new ArrayList<Pipe>();
		createPipe();
	}

	public boolean loop() {
		float curMillis = millis();
		boolean created =  false;

		if (!isDisabled) {
			if (curMillis > lastObstalceCreateMs + PIPE_CREATE_TIME_MILLIS) {
				createPipe();
				lastObstalceCreateMs = curMillis;
				created = true;
			}
		}

		for (int i = 0; i < pipes.size(); i++) {
			Pipe pipe = pipes.get(i);
			
			if (pipe.getXWithWidth() < 0) {
				pipes.remove(0);
				System.out.println("Pipe Removed!!");
			} else {
				if (!isDisabled) pipe.loop(movingSpeed);
				else {
					movingSpeed -= 0.01;
					if (movingSpeed < 0) {
						movingSpeed = 0;
						noLoop();
					}
					
					pipe.loop(movingSpeed);
				}
			}
		}

		return created;
	}

	private void createPipe() {
		System.out.println("Create Pipe!!");
		float topHeight = random(PIPE_MIN_HEIGHT, maxHeight - (PIPE_MIN_HEIGHT + PASS_AREA_HEIGHT));
		float bottomHeight = maxHeight - (topHeight + PASS_AREA_HEIGHT);

		Pipe pipe = new Pipe(0, topHeight, maxWidth - bottomHeight, bottomHeight, 
								maxWidth + PIPE_WIDTH / 2, PIPE_WIDTH);
		pipes.add(pipe);
	}

	public void disable() {
		isDisabled = true;
	}
}

class Pipe {
	float topY, topHeight;
	float bottomY, bottomHeight;
	float x, width;

	public Pipe(float topY, float topHeight, float bottomY, float bottomHeight, float x, float width) {
		setPipe(topY, topHeight, bottomY, bottomHeight, x, width);
	}

	public void loop(float speed) {
		rect(x, topY, width, topHeight);
		rect(x, bottomY, width, bottomHeight);
		x -= speed;
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

	public float getWidth() {
		return this.width;
	}

	public float getXWithWidth() {
		return (getX() + getWidth());
	}
}
