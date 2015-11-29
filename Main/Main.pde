import processing.video.*;

ParticleFilter particleFilter;

Movie movie;

void setup() {

  movie.loop();
  
  // Initialize with first frame
  movie.read();
}


void draw() {
  image(movie, 0, 0);
  
  particleFilter.update(movie);
  particleFilter.drawParticles();
  particleFilter.drawRectangle();
}

void movieEvent(Movie m){
    m.read();
}