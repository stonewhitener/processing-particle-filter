import processing.video.*;

ParticleFilter particleFilter;

Capture cam;

void setup() {
  size(1280, 720);

  String[] cameras = Capture.list();
  
  if (cameras.length == 0) {
    println("There are no cameras available for capture.");
    exit();
  } else {
    println("Available cameras:");
    for (int i = 0; i < cameras.length; i++) {
      println(cameras[i]);
    }
    
    // The camera can be initialized directly using an 
    // element from the array returned by list():
    cam = new Capture(this, cameras[0]);
    cam.start();     
  }  

  // Initialize with first frame
  cam.read();
  particleFilter = new ParticleFilter(1000, 13.0, cam);
}


void draw() {
  if (cam.available() == true) {
    cam.read();
  }
  
  image(cam, 0, 0);

  particleFilter.update(cam);
  particleFilter.drawParticles(color(255, 0, 0), 2);
  particleFilter.drawRectangle(color(255, 0, 0), 2, 30, 30);
}

