import processing.net.*;

final float GRAVITY = 0.5;
final float PIPE_SPEED = 0.1;
final float PIPE_CREATE_TIME_MS = 3000;

final float MAX_WIDTH = 800;
final float MAX_HEIGHT = 800;

final float MIN_PIPE_HEIGHT = 50;
final float PIPE_WIDTH = 25;
final float ROAD_HEIGHT = 200;

boolean jumping;
float x, y, speed;

float lastObstalceCreateMs;

void setup() {
	size(800, 800);
	jumping = false;
	x = 400F;
	y = 400F;
	speed = GRAVITY;

	lastObstalceCreateMs = 0;
}

void draw() {
	background(135, 206, 235);

	ellipse(x, y, 50, 50);

	float curMillis = millis();
	if (curMillis > lastObstalceCreateMs + PIPE_CREATE_TIME_MS) {
		createPipe();
		lastObstalceCreateMs = curMillis;
	}

	if (!jumping) {
		y += speed;
		speed += GRAVITY;
	} else {
		if (speed <= 0) {
			jumping = false;
			speed = 0;
		}

		y -= speed;
		speed -= GRAVITY;
	}
}

void keyReleased() {
	if (key == ENTER) {
		jumping = true;
		speed = 7.5;
	}
}

void createPipe() {
	System.out.println("Create Pipe!!");
	float topHeight = random(MIN_PIPE_HEIGHT, MAX_WIDTH - (ROAD_HEIGHT + MIN_PIPE_HEIGHT));
	float bottomHeight = MAX_HEIGHT - (topHeight + ROAD_HEIGHT);

	{
		FloatDict val = new FloatDict();
		float x, y, w, h;

		x = MAX_WIDTH - 100;
		y = 0;
		w = PIPE_WIDTH;
		h = topHeight;

		val.set("x", x);
		val.set("y", y);
		val.set("w", w);
		val.set("h", h);
		rect(x, y, w, h);

	}

	{
		FloatDict val = new FloatDict();
		float x, y, w, h;

		x = MAX_WIDTH - 100;
		y = MAX_HEIGHT - topHeight;
		w = PIPE_WIDTH;
		h = topHeight;

		val.set("x", x);
		val.set("y", y);
		val.set("w", w);
		val.set("h", h);
		rect(x, y, w, h);
	}
}
