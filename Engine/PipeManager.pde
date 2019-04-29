class PipeManager {
	private static final float PIPE_CREATE_TIME_MILLIS = 6000;
	private static final float PIPE_MIN_HEIGHT = 100;
	private static final float PIPE_WIDTH = 130;
	private static final float PASS_AREA_HEIGHT = 140;

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
