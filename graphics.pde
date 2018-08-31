class Rectangle {
  float x, y;
  float w, h;
  
  Rectangle(float x, float y, float w, float h) {
    this.w = w;
    this.h = h;
    this.x = x;
    this.y = y;
  }
  
  void move(float dx, float dy) {
    x += dx;
    y += dy;
  }
  
  float x2() {
    return x + w;
  }
  
  float y2() {
    return y + h;
  }
    
  boolean intersect(Rectangle rect) {
    if (x > rect.x2() || rect.x > x2())
        return false;
    if (y > rect.y2() || rect.y > y2())
        return false;
    return true;
  }
};

class Entity {
  float vx, vy, ax, ay;
  Rectangle rect;

  Entity(float x, float y, float w, float h) {
    ax = 0;
    ay = 0;
    vx = 0;
    vy = 0;
    rect = new Rectangle(x, y, w, h);
  }

  void update() {
    vx += ax;
    vy += ay;
    rect.move(vx, vy);
  }

  void display() {
    fill(0);
    rect(rect.x, rect.y, rect.w, rect.h);
  }
};
