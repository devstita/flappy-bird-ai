import processing.net.*;

static final float FRAME_RATE = 60;

Bird bird;
PipeManager pipes;

void setup() {
	size(800, 800); // 800 x 800 Window Size
	frameRate(FRAME_RATE); // Default
	smooth(); // Todo: Make Dispaly Smooth

	bird = new Bird(800, 800);
	pipes = new PipeManager(800, 800);
}

void draw() {
	background(135, 206, 235);

	pipes.loop();
	bird.loop();
}

void keyPressed() {
	if (key == ENTER) bird.jump();
}

// Todo: Develop Collision Check Algorithm
class Bird {
	private static final float GRAVITY = 0.5F;
	private static final float JUMPING_FORCE = 7.0F;
	private static final float BIRD_SIZE = 40F;

	float maxWidth, maxHeight;

	float x, y, speed;
	boolean isJumping;

	public Bird(float maxWidth, float maxHeight) {
		this.maxWidth = maxWidth;
		this.maxHeight = maxHeight;

		x = maxWidth / 4;
		y = maxHeight / 2;
		speed = GRAVITY;
		isJumping = false;
	}

	public void loop() {
		ellipse(x, y, BIRD_SIZE, BIRD_SIZE);

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

	public void jump() {
		System.out.println("Jump Bird!!");
		isJumping = true;
		speed = JUMPING_FORCE;
	}
}

class PipeManager {
	private static final float PIPE_CREATE_TIME_MILLIS = 4500;
	private static final float PIPE_MIN_HEIGHT = 100;
	private static final float PIPE_WIDTH = 75;
	private static final float PASS_AREA_HEIGHT = 150;

	float maxWidth, maxHeight;
	float lastObstalceCreateMs;

	ArrayList<Pipe> pipes;

	public PipeManager(float maxWidth, float maxHeight) {
		this.maxWidth = maxWidth;
		this.maxHeight = maxHeight;

		lastObstalceCreateMs = 0F;
		pipes = new ArrayList<Pipe>();
	}

	public boolean loop() {
		float curMillis = millis();
		boolean created =  false;

		if (curMillis > lastObstalceCreateMs + PIPE_CREATE_TIME_MILLIS) {
			createPipe();
			lastObstalceCreateMs = curMillis;
			created = true;
		}

		for (int i = 0; i < pipes.size(); i++) {
			Pipe pipe = pipes.get(i);
			if (pipe.getX() + pipe.getWidth() < 0) {
				pipes.remove(i--);
				System.out.println("Pipe Removed!!");
			} else pipe.loop();
		}

		return created;
	}

	private void createPipe() {
		System.out.println("Create Pipe!!");
		float topHeight = random(PIPE_MIN_HEIGHT, maxHeight - (PIPE_MIN_HEIGHT + PASS_AREA_HEIGHT));
		float bottomHeight = maxHeight - (topHeight + PASS_AREA_HEIGHT);

		Pipe pipe = new Pipe(0, topHeight, maxWidth - bottomHeight, bottomHeight, maxWidth - 100, PIPE_WIDTH);
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

	public float getWidth() {
		return this.width;
	}
}
