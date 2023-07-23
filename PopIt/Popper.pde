class Popper {

  float x, y;
  float sizeX, sizeY;
  color filler = color(0, 0, 0);
  boolean hasbeenPushed = false;
  Popper() {
  }
  void setVars(float x, float y, float sizeX, float sizeY) {
    this.x = x;
    this.y = y;
    this.sizeX = sizeX;
    this.sizeY = sizeY;
  }
  void display() {
    if (hasbeenPushed) {
      filler = color(255, 0, 0);
    }
    if (!hasbeenPushed && !mouseOver()) {
      filler = 0;
    }
    fill(filler);
    noStroke();
    ellipse(x, y, sizeX, sizeY);
  }

  boolean mouseOver() {
    float dx = x - mouseX;
    float dy = y - mouseY;
    float distance = sqrt((dx*dx) + (dy*dy));
    if (distance < sizeX/2) {
      return true;
    }
    return false;
  }
  void clicked() {
    if (mouseOver()) {
      filler = color(70, 255, 70);
      if (mousePressed && mouseButton == LEFT) {
        hasbeenPushed = true;
      }
    }
  }
}
