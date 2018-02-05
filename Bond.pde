class bond {
  atom atom1;
  atom atom2;
  int strength;
  boolean complete = false;
  PVector start = new PVector(0, 0);
  PVector end = new PVector(0, 0);

  bond(atom atom1) {
    strength = 1;
    this.atom1 = atom1;
    start.set(atom1.location);
    end.set(mouseX, mouseY);
  }

  void complete(atom atom2) {
    if (atom2.bonds < atom2.maxBonds) {
      this.atom2 = atom2;
      end.set(atom2.location);
      atom1.bonding[0][atom1.atomsBonded] = atom2.number;
      atom1.bonding[1][atom1.atomsBonded] = 1;
      atom2.bonding[0][atom2.atomsBonded] = atom1.number;
      atom2.bonding[1][atom2.atomsBonded] = 1;
      atom1.bonds++;
      atom1.atomsBonded++;
      atom2.bonds++;
      atom2.atomsBonded++;
      atom1.connected = true;
      atom2.connected = true;
      if (atom1.element == "C") atom2.carbonsBonded++;
      if (atom2.element == "C") atom1.carbonsBonded++;
      complete = true;
    }
  }

  void move(int x, int y) {
    end.set(x, y);
  }

  void update() {
    start.set(atom1.location);
    if (complete) end.set(atom2.location);
  }

  boolean click(int x, int y) {
    float m = (end.y-start.y)/(end.x-start.x);
    float b = end.y-end.x*m;
    if (abs(m*x+b-y) < 5) {
      if (within(x, y)) return true;
    }
    return false;
  }

  boolean within(int x, int y) {
    float lowX;
    float highX;
    float lowY;
    float highY;
    if (atom1.location.x > atom2.location.x) {
      lowX = atom2.location.x;
      highX = atom1.location.x;
    } else {
      lowX = atom1.location.x;
      highX = atom2.location.x;
    }

    if (atom1.location.y > atom2.location.y) {
      lowY = atom2.location.y;
      highY = atom1.location.y;
    } else {
      lowY = atom1.location.y;
      highY = atom2.location.y;
    }
    if (x > lowX-5 && x < highX+5 && y > lowY-5 && y < highY+5) return true;
    return false;
  }

  void increase() {
    if (atom1.bonds < atom1.maxBonds && atom2.bonds < atom2.maxBonds && strength < 3) {
      atom1.bonds++;
      atom1.bonding[1][findBond(atom1, atom2)]++;
      atom2.bonds++;
      atom2.bonding[1][findBond(atom2, atom1)]++;
      strength++;
    }
  }

  void decrease() {
    if (strength > 1) {
      atom1.bonds--;
      atom1.bonding[1][findBond(atom1, atom2)]--;
      atom2.bonds--;
      atom2.bonding[1][findBond(atom2, atom1)]--;
      strength--;
    }
  }

  int findBond(atom a1, atom a2) {
    for (int i = 0; i < a1.atomsBonded; i++) {
      if (a1.bonding[0][i] == a2.number) return i;
    }
    return 0;
  }

  void display() {
    stroke(0);
    float dir1 = atan((end.y-start.y)/(end.x-start.x));
    float dir2 = atan((start.y-end.y)/(start.x-end.x));
    int radius = 15;
    float displacement = 0.3;
    if (strength == 1) {
      strokeWeight(5);
      line(start.x, start.y, end.x, end.y);
    }
    if (strength == 2) {
      strokeWeight(3);
      float angle = atan((end.y-start.y)/(end.x-start.x));
      line(start.x+cos(dir1+displacement)*radius, start.y+sin(dir1+displacement)*radius, end.x+cos(dir2+displacement)*radius, end.y+sin(dir2+displacement)*radius);
      line(start.x+cos(dir1-displacement)*radius, start.y+sin(dir1-displacement)*radius, end.x+cos(dir2-displacement)*radius, end.y+sin(dir2-displacement)*radius);
    }
    if (strength == 3) {
      strokeWeight(3);
      radius = 20;
      line(start.x+cos(dir1+displacement)*radius, start.y+sin(dir1+displacement)*radius, end.x+cos(dir2+displacement)*radius, end.y+sin(dir2+displacement)*radius);
      line(start.x+cos(dir1-displacement)*radius, start.y+sin(dir1-displacement)*radius, end.x+cos(dir2-displacement)*radius, end.y+sin(dir2-displacement)*radius);
      line(start.x, start.y, end.x, end.y);
    }
  }
}