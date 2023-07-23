class Board implements Screen_Object {

  float x, y;
  float size;
  float start;
  float[] chords = {124.225, 157.133, 166.7, 166.665, 157.133, 124.225};
  float[] chord = new float[6];
  ArrayList<Popper[]> pins = new ArrayList<Popper[]>();
  color filler = color(255, 255, 255);
  color background;
  int theOne = -1;

  boolean[] canSelect = new boolean[6];
  boolean locked = false;
  int turn = 0;

  Player[] gamers;
  Board(color background) {

    x = width/2;
    y = height/2;
    size = (x+y)/1.25;
    start = y - size/2;
    this.background = background;
    pins.add(new Popper[3]);
    pins.add(new Popper[5]);
    pins.add(new Popper[6]);
    pins.add(new Popper[6]);
    pins.add(new Popper[5]);
    pins.add(new Popper[3]);
    float n = 5;
    for (int i = 0; i < chord.length; i++) {
      chord[i] = size * (chords[i]/333.33);
      canSelect[i] = true;
      float tempY = start+(i*(size/6)) + ((size/6))/2;
      float tempS = (size/6)*3/4;
      if (i < 3) {
        n = n - (n-1)/2;
      } else if (i == 3) {
        n = 1.5;
      } else n = n + (n-1);

      float tempX = x-(chord[i]/n);
      Popper[] list = pins.get(i);

      for (int k = 0; k < list.length; k++) {
        list[k] = new Popper();
        Popper p = list[k];
        p.setVars(tempX+2*k + tempS*k, tempY, tempS, tempS);
      }
    }
  }

  void setPlayers(Player[] Players) {
    gamers = Players;
  }
  void reset() {
    theOne = -1;
    for (Popper[] list : pins) {
      for (Popper c : list) {
        c.hasbeenPushed = false;
        c.filler = 0;
      }
    }
  }
  int v = 0;
  void unlock() {
    theOne = -1;
    locked = false;

    if (turn == 0 && v == 0) {
      turn = 1;
      v++;
    } else if (turn == 1 && v == 0) {
      turn = 0;
      v++;
    }
    println("Turn:"+turn);
  }
  void display() { 
    int g = 0;
    if (theOne != -1) {
      for (Popper a : pins.get(theOne)) {
        a.clicked();
        if(a.hasbeenPushed) g++;
      }
    }

    for (int i = 0; i < chord.length; i++) {
      float tempX = x-chord[i];
      float tempY = start+(i*(size/6));
      float tempSX = chord[i]*2;
      float tempSY = size/6;
      int n = 0;
      for (Popper b : pins.get(i)) {
        if (b.hasbeenPushed) {
          n++;
        }
      }
      if (n == pins.get(i).length) {
        canSelect[i] = false;
      }
      if (mouseOver(tempX, tempY, tempSX, tempSY) && mousePressed && mouseButton == LEFT && canSelect[i] && !locked) {
        theOne = i;
        locked = true;
        v = 0;
      }
      if (!canSelect[i] && theOne == i) {
        unlock();
      }

      //visual shit
      if (theOne == i) {
        switch(turn) {
        case 0:
          filler = color(0, 0, 255);
          break;
        case 1:
          filler = color(255, 165, 0);
          break;
        }
      }
      fill(filler);
      stroke(255, 0, 255);
      strokeWeight(2);
      rectMode(CORNER);
      rect(tempX, tempY, tempSX, tempSY);
    }
    for (Popper[] list : pins) {
      for (Popper p : list) {
        p.display();
      }
    }
    if (keyPressed && g > 0) {
      if (key == CODED) {
        if (keyCode == SHIFT){
          unlock();
          g = 0;
        }
      }
    }


    noFill();
    stroke(background);
    //strokeWeight(1);
    //ellipse(x, y, size, size);
    strokeWeight(size/6);
    rectMode(CENTER);
    ellipse(x, y, size+size/6, size+size/6);
    //rect(x, y, size+size/6, size+size/6);
    endShape();
    if (gameover() != (null)) {
      System.out.printf("%s lost%n ", gameover());
    }
  }
  Player gameover() {
    int n = 0;
    for (boolean m : canSelect) {
      if (!m) {
        n++;
      }
    }
    if (n == canSelect.length && turn == 0) {    
      return gamers[1];
    } else if(n == canSelect.length && turn == 1) return gamers[0];
    return null;
  }
  boolean mouseOver(float x, float y, float wid, float len) {
    float dx = mouseX - this.x;
    float dy = mouseY - this.y;
    float distance = sqrt((dx*dx) + (dy*dy));
    if (distance < size/2 + 1) {
      if (mouseX < x+wid && mouseX > x && mouseY < y+len && mouseY > y) {
        filler = 127;
        return true;
      }
    }
    filler = 255;
    return false;
  }
}
