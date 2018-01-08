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
    atom1.bonds++;
    start.set(atom1.location);
    end.set(mouseX, mouseY);
  }

  void complete(atom a2) {
    if (a2.bonds < a2.maxBonds) {
      atom2 = a2;
      atom2.bonds++;
      end.set(atom2.location);
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
    if (abs(m*x+b-y) < 5) return true;
    return false;
  }

  void increase() {
    if (atom1.bonds < atom1.maxBonds && atom2.bonds < atom2.maxBonds) {
      atom1.bonds++;
      atom2.bonds++;
      strength++;
    }
  }

  void decrease() {
    strength--;
    if (strength < 1) {
      //this = null;
    }
  }

  void display() {
    stroke(0);
    if (strength == 1) {
      strokeWeight(5);
      line(start.x, start.y, end.x, end.y);
    }
    if (strength == 2) {
      strokeWeight(3);
      float angle = atan((end.y-start.y)/(end.x-start.x));
      line(start.x+3, start.y+3, end.x+3, end.y+3);
      line(start.x-3, start.y-3, end.x-3, end.y-3);
    }
  }
}