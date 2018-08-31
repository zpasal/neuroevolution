int PLAYER_STATE_IDLE = 0;
int PLAYER_STATE_JUMPING = 1;
int PLAYER_STATE_CRAWLING = 2;

class Player extends Entity {
  int state = PLAYER_STATE_IDLE;
  boolean killed = false;
  float fitness = 0;
  String name;
  int crawlFrames;
  
  int[] topology = new int[] {99, 132, 2};
  Network brain;

  Player(String name) {
    super(100, 300, 30, 90);
    this.name = name;
    ay = .62;
    
    NetworkBuilder nb = new NetworkBuilder(topology);
    brain = nb.build();
  }
  
  void think() {
    brain.run(Vision.screen);
    float jump = brain.layers.get(2).outputs[0];
    float crawl = brain.layers.get(2).outputs[1];
    //print(jump, "  ", crawl, "\n");
    if (crawl > 0.8) {
      doCrawl();
    }
    else if (jump  > 0.8) {
      doJump();
    }
    else {
      doIdle();
    }
  }
  
  void doJump() {
    if (state == PLAYER_STATE_IDLE) {
      rect.h = 90;
      vy = -10;
      state = PLAYER_STATE_JUMPING;
    }
  }
  
  void doCrawl() {
    if (state == PLAYER_STATE_IDLE) {
      state = PLAYER_STATE_CRAWLING;
      rect.h = 55;
    }
  }
  
  void doIdle() {
    if (state == PLAYER_STATE_CRAWLING) {
      state = PLAYER_STATE_IDLE;
      rect.h = 90;
    }
  }
  
  void display() {
    noFill();
    rect(rect.x, rect.y, rect.w, rect.h);
  }
  
  void update() {
    super.update();
    if (rect.y > height - rect.h) {
      rect.y = height - rect.h;
      vy = 0;
      state = PLAYER_STATE_IDLE;
    }
    fitness++;
  }
  
  void mutate() {
    for (int i=0; i<topology.length; i++) {
      int idx = int(random(0, 2));
      ArrayList<Perceptron> perceptrons = brain.layers.get(idx).perceptrons;
      perceptrons.get(int(random(0, perceptrons.size()-1))).mutate();
    }
  }
};

class Bush extends Entity {
  Bush(float x) {
    super(x, height-30, 30, 30);
    ax = -1 * random(0.01, 0.15);
  }
};

class Bird extends Entity {
  Bird(float x) {
    super(x, height-90, 30, 30);
    ax = -1 * random(0.01, 0.15);
  }
};
