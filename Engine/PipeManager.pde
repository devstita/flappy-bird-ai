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

	private ArrayList<Pipe> frontPipes;
	private ArrayList<Pipe> backPipes;

	public PipeManager(float maxWidth, float maxHeight, Bird bird) {
		this.maxWidth = maxWidth;
		this.maxHeight = maxHeight;
		this.bird = bird;

		lastObstalceCreateMs = 0F;
		movingSpeed = 1;
		isDisabled = false;

		frontPipes = new ArrayList<Pipe>();
		backPipes = new ArrayList<Pipe>();
		
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

		for (int i = 0; i < frontPipes.size(); i++) {
			Pipe pipe = frontPipes.get(i);
			if (pipe.getXRightPipe() < bird.getXLeftBird()) {
				backPipes.add(pipe);
				frontPipes.remove(i--);
				if (!isDisabled) pipePassed();
			} else {
				if (!isDisabled) {
					pipe.loop(movingSpeed);
					
					if (pipe.isCollided(bird)) {
						gameOver();
						break;
					}
				} else {
					movingSpeed -= 0.01;
					if (movingSpeed < 0) {
						movingSpeed = 0;
						noLoop();
					}
					
					pipe.loop(movingSpeed);
				}
			}
		}

		for (int i = 0; i < backPipes.size(); i++) {
			Pipe pipe = backPipes.get(i);
			
			if (pipe.getXRightPipe() < 0) {
				backPipes.remove(i--);
			} else {
				pipe.loop(movingSpeed);
			}
		}

		return created;
	}

	private void createPipe() {
		float topHeight = random(PIPE_MIN_HEIGHT, maxHeight - (PIPE_MIN_HEIGHT + PASS_AREA_HEIGHT));
		float bottomHeight = maxHeight - (topHeight + PASS_AREA_HEIGHT);

		Pipe pipe = new Pipe(0, topHeight, maxHeight - bottomHeight, bottomHeight, 
								maxWidth, PIPE_WIDTH);
		frontPipes.add(pipe);
	}

	public Pipe getNearestFrontPipe() {
		if (frontPipes.isEmpty()) return null;
		else return frontPipes.get(0);
	}

	public void disable() {
		isDisabled = true;
	}
}
