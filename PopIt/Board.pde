class Board implements Screen_Object {

  float x, y;
  float size;
  float start;
  float[] chords = {124.225, 157.133, 166.7, 166.665, 157.133, 124.225};
  float[] chord = new float[6];
  ArrayList<Popper[]> pins = new ArrayList<Popper[]>();
  color filler = color(255, 255, 255);
  color background;
  int theOne = -1;// set the selected row

  boolean[] canSelect = new boolean[6];// checks if row can be selected
  int[] f = new int[6];// checks if player hit new pin
  boolean locked = false;//locks player into their row
  boolean play = false;//allows to play the game used to wait so it doesnt autoclick the gameboard
  int turn = -1;//used to control which turn we are on
  int v = 0;//controls the changing of turns
  Player[] gamers;
  Screen imon;

  Board(color background, Screen imon) {
    this.imon = imon;
    x = width/2;
    y = height/2;
    size = (x+y)/1.5;
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
    play = false;
    theOne = -1;
    turn = -1;
    locked = false;
    for (Popper[] list : pins) {
      for (Popper c : list) {
        c.hasbeenPushed = false;
        c.filler = 0;
      }
    }
    for (int i = 0; i < canSelect.length; i++) {
      canSelect[i] = true;
      f[i] = 0;
    }
    v = 0;
  }

  void unlock() {
    theOne = -1;
    locked = false;
    if (!gameOver()) {
      if (turn == 0 && v == 0) {
        turn = 1;
        v++;
      } else if (turn == 1 && v == 0) {
        turn = 0;
        v++;
      }
    }
  }

  void display() { 
    int g = 0;//how many clicked
    //int c = 0;// how many not clicked

    if (theOne != -1) {
      for (Popper a : pins.get(theOne)) {
        a.clicked();
        if (a.hasbeenPushed) {
          g++;
        }// else c++;
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
      //select row
      if (mouseOver(tempX, tempY, tempSX, tempSY) && mousePressed && mouseButton == LEFT && canSelect[i] && !locked && play) {
        theOne = i;
        locked = true;
        v = 0;
        //println("reeeeeeeeeee");
      }

      //changes turns
      if (theOne != -1) {
        //if (keyPressed  && g > f[theOne]) {
        //  if (key == CODED) {
        //    if (keyCode == SHIFT) {
        //      f[theOne] = g;
        //      unlock();
        //    }
        //  }
        //}
        //if (g > f[theOne]) {
        //  if (mousePressed && mouseButton == RIGHT) {
        //    f[theOne] = g;
        //    unlock();
        //  }
        //}
        if (g > f[theOne]) {
          if (imon.button(width - 60, height*.8, 100, 30, "Next Turn")) {
            f[theOne] = g;
            unlock();
          }
        }
      }
      //automatically unlocked when selecting all pins
      if (!canSelect[i] && theOne == i) {
        unlock();
      }
      //visual shit
      if (theOne == i && locked) {
        switch(turn) {
        case 0:
          filler = color(0, 0, 255);
          break;
        case 1:
          filler = color(255, 165, 0);
          break;
        }
      }
      pushMatrix();
      fill(filler);
      stroke(255, 0, 255);
      strokeWeight(2);
      rectMode(CORNER);
      rect(tempX, tempY, tempSX, tempSY);
      popMatrix();
    }
    for (Popper[] list : pins) {
      for (Popper p : list) {
        p.display();
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
    pushMatrix();
    textSize(48);
    textAlign(CENTER, CENTER);
    fill(255);
    text(gamers[turn].toString(), width/2, height*.05);
    popMatrix();
    if (gameOver()) {
      System.out.printf("%s lost%n ", gamers[turn]);
    }
    if (!mousePressed) play = true;
  }
  boolean gameOver() {
    int n = 0;
    for (boolean m : canSelect) {
      if (!m) {
        n++;
      }
    }
    if (n == canSelect.length) {    
      return true;
    }
    return false;
  }
  void setTurn(int t) {
    play = false;
    turn = t;
  }
  Player getLoser() {
    if (gameOver()) {
      return gamers[turn];
    }
    return null;
  }
  boolean mouseOver(float x, float y, float wid, float len) {
    float dx = mouseX - this.x;
    float dy = mouseY - this.y;
    float distance = sqrt((dx*dx) + (dy*dy));
    if (distance < size/2 + 1) {
      if (mouseX < x+wid && mouseX > x && mouseY < y+len && mouseY > y) {
        filler = 127;
        if (locked) filler = 255;
        return true;
      }
    }
    filler = 255;
    return false;
  }
  String toString() {
    return "Turn:"+turn;
  }
}
