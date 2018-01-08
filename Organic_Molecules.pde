ArrayList <atom> atoms = new ArrayList <atom>();
ArrayList <bond> bonds = new ArrayList <bond>();
boolean clicking;
int atomClicked;
int[] newAtoms = {0, 1, 2};

void setup() {
  size(1000, 700);
  reset();
}

void reset() {
  atoms.add(new atom("C"));
  atoms.add(new atom("H"));
  atoms.add(new atom("O"));
}

void draw() {
  background(230);
  ui();
  update();
  display();
}

void ui() {
  strokeWeight(0);
  fill(220);
  rect(800, 0, 400, 700);
}

void update() {
  for (int i = 0; i < atoms.size(); i++) {

    if (atoms.get(i).clicked) {
      atoms.get(i).move(mouseX, mouseY);
    }
    if (atoms.get(i).location.x < 700) atoms.get(i).inUse = true;
  }
  for (int i = 0; i < bonds.size(); i++) {
    bonds.get(i).update();
    if (!bonds.get(i).complete) bonds.get(i).move(mouseX, mouseY);
  }
}

void display() {
  for (int i = 0; i < bonds.size(); i++) bonds.get(i).display();
  for (int i = 0; i < atoms.size(); i++) atoms.get(i).display();
}

void mousePressed() {
  if (mouseButton == LEFT) leftClick();
  if (mouseButton == RIGHT) rightClick();
}

void leftClick() {
  if (!clicking) {
    boolean done = false;
    for (int i = 0; i < atoms.size(); i++) {
      if (atoms.get(i).click(mouseX, mouseY)) {
        done = true;
        atoms.get(i).clicked();
        clicking = true;
        atomClicked = i;
        for (int h = 0; h < newAtoms.length; h++) {
          if (i == newAtoms[h]) {
            atoms.add(new atom(atoms.get(i).element));
            newAtoms[h] = atoms.size()-1;
          }
        }
        i = atoms.size();
      }
    }
    if (!done) {
      for (int i = 0; i < bonds.size(); i++) {
        if (bonds.get(i).click(mouseX, mouseY)) {
          bonds.get(i).increase();
          i = bonds.size();
        }
      }
    }
  } else {
    atoms.get(atomClicked).clicked = false;
    clicking = false;
  }
}

void rightClick() {
  boolean done = false;
  if (!clicking) {
    for (int i = 0; i < atoms.size(); i++) {
      if (atoms.get(i).click(mouseX, mouseY)) {
        println(atoms.get(i).bonds);
        if (atoms.get(i).bonds < atoms.get(i).maxBonds) {
          bonds.add(new bond(atoms.get(i)));
          atomClicked = i;
          clicking = true;
        }
      }
      done = true;
      i = atoms.size();
    }
    if (!done) {
      for (int i = 0; i < bonds.size(); i++) {
        if (bonds.get(i).click(mouseX, mouseY)) {
          bonds.get(i).decrease();
        }
      }
    }
  } else {
    for (int i = 0; i < atoms.size(); i++) {
      if (atoms.get(i).click(mouseX, mouseY) && bonds.get(bonds.size()-1).atom1 != atoms.get(i)) {
        bonds.get(bonds.size()-1).complete(atoms.get(i));
        done = true;
      }
    }
    if (!done) {
      bonds.remove(bonds.size()-1);
      atoms.get(atomClicked).bonds--;
    }
    clicking = false;
  }
}

void keyPressed() {
  if (key == ' ') clear();
}