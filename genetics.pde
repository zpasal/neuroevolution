class Population {
  ArrayList<Player> players = new ArrayList<Player>();
  int id;
  
  Population() {
    this.id = populationId++;
  }

  public void init(int playerCount) {
    for (int i=0; i<playerCount; i++) {
      players.add(new Player(str(i)));
    }
  }
  
  boolean isAlive() {
    for (Player player : players) {
      if (!player.killed) {
        return true;
      }
    }
    return false;
  }
  
  int liveCount() {
    int live = 0;
    for (Player player : players) {
      if (!player.killed) {
        live++;
      }
    }
    return live;
  }
  
  void update() {
    for (Player player : players) {
      if (!player.killed) {
        player.think();    
        player.update();
      }
    }
  }
  
  void display() {
    for (Player player : players) {
      if (!player.killed) { 
        player.display();
      }
    }
  }
};

class Evolution {
  ArrayList<Player> matingPool = new ArrayList<Player>();
  ArrayList<Player> kids = new ArrayList<Player>();

  Population population;
  
  Evolution(Population population) {
    this.population = population;
  }
  
  Population evolve() {
    selection();
    reproduction();
    mutation();
    
    return buildPopulation();
  }
  
  void selection() {
    float sum = 0;
    for (Player player : population.players) {
      sum += player.fitness;
    }
    for (Player player : population.players) {
      player.fitness = (player.fitness * 100) / sum;
    }
    
    println("------------------------------------------");
    for (Player player : population.players) {
      int n = int(player.fitness);
      //println("Adding " + n + " player ", player.name, " score: " + player.fitness);
      for (int i = 0; i < n; i++) {
        matingPool.add(player);
      }
    }
    //println("Mating pool size: " + matingPool.size());
  }
  
  void reproduction() {
    int populationSize = population.players.size();
    for (int i=0; i<populationSize; i++) {
      Player p1 = matingPool.get(int(random(matingPool.size())));
      Player p2 = matingPool.get(int(random(matingPool.size())));
      kids.add(mate(p1, p2));
    }
  }

  Player mate(Player p1, Player p2) {
    Player kid = new Player(p1.name);
    
    NetworkSerializer serializer1 = new NetworkSerializer(p1.brain);
    NetworkSerializer serializer2 = new NetworkSerializer(p2.brain);
    
    ArrayList<Float> p1weights = serializer1.collectWeights();
    ArrayList<Float> p2weights = serializer2.collectWeights();
    
    ArrayList<Float> kidWights = new ArrayList<Float>(p1weights.subList(0, p1weights.size()/2));
    int addOneMore = p1weights.size() % 3 == 0 ? 1 : 0;
    kidWights.addAll(p2weights.subList(0, p2weights.size()/2 + addOneMore));
    
    NetworkSerializer kidSerializer = new NetworkSerializer(kid.brain);
    kidSerializer.storeWeights(kidWights);

    return kid;
  }
  
  void mutation() {
    float mutationRate = 0.01;
    for (Player kid : kids) {
      if (random(1) < mutationRate) {
        kid.mutate();
      }
    }
  }
  
  Population buildPopulation() {
    Population newPopulation = new Population();
    for (Player kid : kids) {
      newPopulation.players.add(kid);
    }
    return newPopulation;
  }
  
};
