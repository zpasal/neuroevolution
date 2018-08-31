static class Vision {
  static float[] screen;
  static int w, h, hCut;
  
  static void init(int _w, int _h, int _hCut) {
    w = _w;
    h = _h;
    hCut = _hCut;
    screen = new float[w * (h - hCut)];
  }
  
  static void addEntity(Entity entity) {
    int x = int(entity.rect.x / 30.0);
    int y = int(entity.rect.y / 30.0) - hCut;
    if (x >= w || y >= h) { return ; }
    setp(x, y, 1.0);
  }
  
  static void setp(int x, int y, float value) {
    screen[x + y * w] = value;
  }
  
  static float getp(int x, int y) {
    return screen[x + y * w];
  }
  
  static void dump(PApplet applet, int px, int py) {
    int size = 8;
    for (int y=0; y<h-hCut; y++) {
      for (int x=0; x<w; x++) {
        if (getp(x, y) > 0) {
          applet.fill(getp(x, y));
        }
        else {
          applet.noFill();
        }
        applet.rect(px + x*size, py + y*size, size, size);
      }
    }
  }
};
