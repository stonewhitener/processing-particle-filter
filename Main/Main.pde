import processing.video.*;

ParticleFilter particleFilter;

Movie movie;

void setup() {
  size(352, 240);

  movie = new Movie(this, "input.mpg");
  movie.loop();
  
  // Initialize with first frame
  movie.read();
  particleFilter = new ParticleFilter(100, movie);
}


void draw() {
  image(movie, 0, 0);
  
  particleFilter.update(movie);
  particleFilter.drawParticles(color(255, 0, 0), 2);
  particleFilter.drawRectangle(color(255, 0, 0), 4, 30, 30);
}

void movieEvent(Movie m){
    m.read();
}