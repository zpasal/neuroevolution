class Scene { //<>//
  ArrayList<Entity> enemies = new ArrayList<Entity>();
  Population population = new Population();
  long steps = 0;

  int level = 1;
  
  void init() {
    randomSeed(0);
    population.init(50);
    enemies.add(new Bird(width));
  }
  
  void update() {
    if (population.isAlive()) {
      ArrayList<Entity> survivedEnemies = new ArrayList<Entity>();
    
      for (Entity enemy : enemies) {
        enemy.update();
        
        Vision.addEntity(enemy);
        for (Player player : population.players) {
          if (!player.killed && player.rect.intersect(enemy.rect)) {
            player.killed = true;
          }    
        }
        if (enemy.rect.x >= 0) {
          survivedEnemies.add(enemy);
        }
      }
  
      population.update();
  
      enemies = survivedEnemies;
      checkLevel();
      steps++;
    }
    else {
      println("Max steps : ", steps);
      reset();
    }
  }  
  
  void reset() {
    Evolution evolution = new Evolution(population);
    population = evolution.evolve();

    enemies = new ArrayList<Entity>();
    steps = 0;
  }
  
  void checkLevel() {
    if (enemies.isEmpty()) {
      for (int i=0; i<level; i++) {
        int enemySelector = int(random(0, 2));
        if (enemySelector == 1) {
          enemies.add(new Bird(width + random(width/2)));
        }
        else {
          enemies.add(new Bush(width + random(width/2)));
        }
      }
    }
  }
  
  void display() {
    for (Entity enemy : enemies) {
      enemy.display();
    }
    population.display();
  }
};
