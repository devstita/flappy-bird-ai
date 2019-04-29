class Pipe {
	private float topY, topHeight;
	private float bottomY, bottomHeight;
	private float x, width;

	public Pipe(float topY, float topHeight, float bottomY, float bottomHeight, float x, float width) {
		setPipe(topY, topHeight, bottomY, bottomHeight, x, width);
	}

	// TODO: Pipe Texture
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
