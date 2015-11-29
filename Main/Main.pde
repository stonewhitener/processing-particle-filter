ParticleFilter particleFilter;
PImage image;
boolean isFirstFrame;

void setup() {
  size(768, 576);

  isFirstFrame = true;

  image = loadImage("test-0000308.jpg");
  particleFilter = new ParticleFilter(500, image);
}


void draw() {
  image(image, 0, 0, 768, 576);
  
  particleFilter.update(image);
  particleFilter.drawParticles();
  particleFilter.drawRectangle();
}