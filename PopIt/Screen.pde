class Screen implements Screen_Object {
  ArrayList<Screen_Object> screenlist = new ArrayList<Screen_Object>();
  String screenName;
  boolean screenOn = true;
  Screen(String screenName) {
    this.screenName = screenName;
  }

  void display() {
    if (screenOn) {
      for (Screen_Object o : screenlist) {
        o.display();
      }
    }
  }
  void reset() {
    for (Screen_Object o : screenlist) {
      o.reset();
    }
  }
  Screen_Object getSObject(int index ) {
    //System.out.printf("%s%n", screenlist.get(index));
    return screenlist.get(index);
  }
  Board getBoard(int index) {
    for (int i = 0; i < screenlist.size(); i++) {
      Screen_Object p = screenlist.get(i);
      if (p instanceof Board && i == index) {
        return (Board) p;
      }
    }
    return null;
  }
  void addScreenObject(Screen_Object o) {
    screenlist.add(o);
  }
  void addScreenObject(Screen_Object[] o) {
    for (Screen_Object p : o) screenlist.add(p);
  }

  void removeScreenObject(Screen_Object o) {
    for (int i = 0; i < screenlist.size(); i++) {
      if (screenlist.get(i) == o) {
        screenlist.remove(i);
      }
    }
  }
  void turnScreenOff() {
    screenOn = false;
  }

  void turnScreenOn() {
    screenOn = true;
  }

  String toString() {
    return screenName;
  }
  void addText(String s, float x, float y, int size, color c) {
    if (screenOn) {
      pushMatrix();
      fill(c);
      textSize(size);
      textAlign(CENTER, CENTER);
      text(s, x, y);
      popMatrix();
    }
  }
  boolean button(float x, float y, float wid, float len, String text) {
    if (screenOn) {
      pushMatrix();
      stroke(255);
      strokeWeight(2);
      fill(127);
      rectMode(CENTER);
      rect(x, y, wid, len);
      fill(255);
      textAlign(CENTER, CENTER);
      textSize(18);
      text(text, x, y, wid, len);
      popMatrix();

      if (mousePressed && mouseButton == LEFT && (mouseX < x+wid/2 && mouseX > x-wid/2 && mouseY < y+len/2 && mouseY > y-len/2)) {
        //println(text+" has been clicked");
        return true;
      }
    }
    return false;
  }
}
