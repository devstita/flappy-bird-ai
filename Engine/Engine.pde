import processing.net.*;

static final float MAX_WIDTH = 800;
static final float MAX_HEIGHT = 800;
static final float FRAME_RATE = 60; // Default

Bird bird;
PipeManager pipeManager;

boolean keyInputed;
boolean isGameOver;

void setup() {
	size(800, 800);
	frameRate(FRAME_RATE);
	smooth();
	noStroke();

	bird = new Bird(MAX_WIDTH, MAX_HEIGHT);
	pipeManager = new PipeManager(MAX_WIDTH, MAX_HEIGHT, bird);

	keyInputed = false;
	isGameOver = false;
}

void draw() {
	background(135, 206, 235);

	pipeManager.loop();
	bird.loop();

	if (isGameOver) gameOver();
}

void keyPressed() {
	if (!keyInputed && !isGameOver && key == ENTER) bird.jump();
	keyInputed = true;
}

void keyReleased() {
	keyInputed = false;
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
	 * datas.size() = 4
	 * datas.get(0) = bird distance from bottom
	 * datas.get(1) = bird distance from nearest front 
	 * datas.get(2) = bird distance from top position of pass area
	 * datas.get(3) = bird distance from bottom position of pass area
	 */
	 return datas;
}

class Bird {
	private static final float GRAVITY = 0.5F;
	private static final float JUMPING_FORCE = 7.0F;
	private static final float BIRD_SIZE = 40F;

	private float maxWidth, maxHeight;

	private PImage image;

	private float x, y, speed;
	private boolean isDisabled, isJumping;

	public Bird(float maxWidth, float maxHeight) {
		this.maxWidth = maxWidth;
		this.maxHeight = maxHeight;

		image = loadImage("flappy-bird.png");

		x = maxWidth / 4;
		y = maxHeight / 2;
		speed = GRAVITY;

		isDisabled = false;
		isJumping = false;
	}

	public void loop() {
		// ellipse(x, y, BIRD_SIZE, BIRD_SIZE);
		imageMode(CENTER);
		image(image, x, y, BIRD_SIZE, BIRD_SIZE);

		if (getYUnderBird() >= maxHeight) gameOver();

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
		isJumping = true;
		speed = JUMPING_FORCE;
	}

	public float getXLeftBird() {
		return (this.x - BIRD_SIZE / 2);
	}

	public float getXRightBird() {
		return (this.x + BIRD_SIZE / 2);
	}

	public float getYUpperBird() {
		return (this.y - BIRD_SIZE / 2);
	}

	public float getYUnderBird() {
		return (this.y + BIRD_SIZE / 2);
	}

	public void disable() {
		this.isDisabled = true;
	}
}

class PipeManager {
	private static final float PIPE_CREATE_TIME_MILLIS = 4500;
	private static final float PIPE_MIN_HEIGHT = 100;
	private static final float PIPE_WIDTH = 75;
	private static final float PASS_AREA_HEIGHT = 150;

	private float maxWidth, maxHeight;
	private Bird bird;

	private float lastObstalceCreateMs;
	private float movingSpeed;
	private boolean isDisabled;

	private ArrayList<Pipe> pipes;

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
			
			if (pipe.getXRightPipe() < 0) {
				pipes.remove(i--);
			} else {
				if (!isDisabled) if (pipe.isCollided(bird)) {
					gameOver();
					break;
				}

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
		float topHeight = random(PIPE_MIN_HEIGHT, maxHeight - (PIPE_MIN_HEIGHT + PASS_AREA_HEIGHT));
		float bottomHeight = maxHeight - (topHeight + PASS_AREA_HEIGHT);

		Pipe pipe = new Pipe(0, topHeight, maxHeight - bottomHeight, bottomHeight, 
								maxWidth, PIPE_WIDTH);
		pipes.add(pipe);
	}

	public void disable() {
		isDisabled = true;
	}
}

class Pipe {
	private float topY, topHeight;
	private float bottomY, bottomHeight;
	private float x, width;

	public Pipe(float topY, float topHeight, float bottomY, float bottomHeight, float x, float width) {
		setPipe(topY, topHeight, bottomY, bottomHeight, x, width);
	}

	public void loop(float speed) {
		rect(x, topY, width, topHeight);
		rect(x, bottomY, width, bottomHeight);
		x -= speed;
	}

	public boolean isCollided(Bird bird) {
		if (bird.getYUnderBird() <= 0) {
			return (bird.getXRightBird() >= this.x && bird.getXLeftBird() <= getXRightPipe());
		} else {
			boolean topPipeLeftCollision = (bird.getXRightBird() >= this.x && bird.getYUpperBird() <= this.topHeight);
			boolean topPipeRightCollision = (bird.getXLeftBird() <= getXRightPipe() && bird.getYUpperBird() <= this.topHeight);
			boolean bottomPipeLeftCollision = (bird.getXRightBird() >= this.x && bird.getYUnderBird() >= this.bottomY);
			boolean bottomPipeRightCollision = (bird.getXLeftBird() <= getXRightPipe() && bird.getYUnderBird() >= this.bottomY);
			
			return ((topPipeLeftCollision && topPipeRightCollision)
				|| (bottomPipeLeftCollision && bottomPipeRightCollision));
		}
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

	public float getXRightPipe() {
		return (getX() + getWidth());
	}
}
