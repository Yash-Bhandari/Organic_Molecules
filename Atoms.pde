class atom {
  color c;
  int number;
  int diameter;
  int maxBonds;
  int bonds = 0;
  int atomsBonded = 0;
  int carbonsBonded = 0;
  int xOffset = -7;
  int yOffset = 7;
  int [][] bonding = new int[2][4];
  //bonding[0][x] contains location of atom bonded to
  //bonding[1][x] denotes bond strength
  String element;
  boolean clicked = false;
  boolean inUse = false;
  boolean connected = false;
  PVector location = new PVector (0, 0);

  atom (String e) {
    location.x = 900;
    switch(e) {
    case "C":
      c = color(230, 230, 10);
      diameter = 50;
      maxBonds = 4;
      location.y = 100;
      break;
    case "H":
      c = color(10, 10, 255);
      diameter = 30;
      maxBonds = 1;
      location.y = 200;
      break;
    case "O":
      c = color(250, 10, 10);
      diameter = 50;
      maxBonds = 2;
      location.y = 300;
      break;
    }
    number = currentAtom;
    element = e;
    currentAtom++;
  }

  void display() {
    noStroke();
    fill(c);
    ellipse(location.x, location.y, diameter, diameter);
    fill(0);
    textSize(20);
    text(number, location.x+xOffset, location.y+yOffset);
  }

  void move(int x, int y) {
    location.x = x;
    location.y = y;
    if (location.x < 800) {
      inUse = true;
    }
    if (location.x > 800 && inUse) {
      inUse = false;
      location.x = 900;
      if (element == "C") location.y = 100;
      if (element == "H") location.y = 200;
      clicked = false;
      clicking = false;
    }
  }

  void clicked() {
    clicked = true;
  }

  boolean click(int x, int y) {
    if (mag(x-location.x, y-location.y) <= diameter/2) return true;
    return false;
  }

  boolean within(int a, int low, int high) {
    if (a > low && a < high) return true; 
    return false;
  }
}