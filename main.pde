int populationId = 0;

Scene scene = new Scene();

void setup() {
  size(990, 600); 
  frameRate(400);
  scene.init();
}

void draw() {
  background(255);
  
  Vision.init(33, 20, 20-3);
  
  scene.display();
  scene.update();
  
  Vision.dump(this, width - 300, 10);
  text("Population: " + scene.population.id, 10, 15); 
  text("Fitness: " + scene.steps, 10, 30); 
  text("Live count: " + scene.population.liveCount(), 10, 45); 
}
