class Bird {
	private static final float GRAVITY = 0.5F;
	private static final float DYING_GRAVITY = 1.0F;
	private static final float JUMPING_FORCE = 7.5F;
	private static final float BIRD_SIZE = 45F;

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
		} else {
			speed += DYING_GRAVITY;
			y += speed;
		}
	}

	public void jump() {
		isJumping = true;
		speed = JUMPING_FORCE;
	}

	public float getXCenterBird() {
		return this.x;
	}

	public float getXLeftBird() {
		return (this.x - BIRD_SIZE / 2);
	}

	public float getXRightBird() {
		return (this.x + BIRD_SIZE / 2);
	}

	public float getYCenterBird() {
		return this.y;
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
