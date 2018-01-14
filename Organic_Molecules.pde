atom[] atoms = new atom[99];
ArrayList <bond> bonds = new ArrayList <bond>();
boolean clicking;
int atomClicked;
int currentAtom;
int[] newAtoms = {0, 1, 2};
int c = 0;
int h = 0;
int o = 0;
int current;
int [] longest;
int [] last;
int [] checked;

void setup() {
  size(1000, 700);
  reset();
}

void reset() {
  currentAtom = 0;
  atoms[currentAtom] = new atom("C");
  atoms[currentAtom] = new atom("H");
  atoms[currentAtom] = new atom("O");
}

void draw() {
  background(230);
  ui();
  update();
  display();
  //println(clicking);
}

void ui() {
  strokeWeight(0);
  fill(220);
  rect(800, 0, 400, 700);
}

void update() {
  for (int i = 0; i < currentAtom; i++) {

    if (atoms[i].clicked) {
      atoms[i].move(mouseX, mouseY);
    }
    if (atoms[i].location.x < 700) atoms[i].inUse = true;
  }
  for (int i = 0; i < bonds.size(); i++) {
    bonds.get(i).update();
    if (!bonds.get(i).complete) bonds.get(i).move(mouseX, mouseY);
  }
}

//names the organic molecule
void name() {
  boolean alkane = true;
  boolean cyclo = false;
  c = 0;
  h = 0;
  o = 0;

  atom[] used = findUsed();
  checked = new int[999];
  longest = new int[0];
  last = new int[999];
  for (int i = 0; i < used.length; i++) {
    if (startingCarbon(used[i])) {
      last[0] = used[i].number;
      current = 0;
      checked[current] = used[i].number;
      current++;
      nextCarbon(used[i]);
      println("Atom", used[i].number, "could be a starting carbon");
    }
  }
  if (o == 0 && h == c*2+2) alkane = true;
  println("Longest chain is", longest.length, "long");
  println("It is comprised of ");
  for (int i = 0; i < longest.length; i++) print(longest[i]);
  println();
  if (alkane) {
    switch(longest.length) {
    case 1: 
      println("methane");
      break;
    case 2: 
      println("ethane");
      break;
    case 3: 
      println("propane");
      break;
    case 4: 
      println("butane");
      break;
    case 5: 
      println("pentane");
      break;
    case 6: 
      println("hexane");
      break;
    case 7: 
      println("heptane");
      break;
    case 8: 
      println("octane");
      break;
    }
  }
}

void branches() {
  for (int i = 0; i < longest.length; i++) {
    if (atoms[longest[i]].carbonsBonded > 2) {
      for (int j = 0; j < atoms[longest[i]].atomsBonded; j++) {
        boolean branch = false;
        if (i > 0) {
          if (atoms[longest[i]].bonding[0][j] != longest[i-1]) branch = true;
        }
        if (i < longest.length-1) {
         if (atoms[longest[i]].bonding[0][j] != longest[i+1]) branch = true;
        }
        if (branch)
      }
    }
  }
}

//recursive function that will check all possible chains from a starting carbon and stores the longest one
void nextCarbon(atom c) {
  for (int i = 0; i < c.atomsBonded; i++) {
    if (atoms[c.bonding[0][i]].element == "C" && c.bonding[0][i] != last[current-1]) {
      last[current] = c.number;
      checked[current] = c.bonding[0][i];
      current++;
      nextCarbon(atoms[c.bonding[0][i]]);
    }
  }
  if (current > longest.length) {
    longest = new int[current];
    for (int i = 0; i < current; i++) longest[i] = checked[i];
  }
  current--;
}

//returns an array containing all atoms that are used in the molecule
atom[] findUsed() {
  int[] temp = new int [currentAtom];
  int total = 0;
  for (int i = 0; i < currentAtom; i++) {
    if (atoms[i].connected) {
      if (atoms[i].element == "C") {
        c++;
        temp[total] = i;
        total++;
      }
      if (atoms[i].element == "H") h++;
      if (atoms[i].element == "O") o++;
    }
  }

  atom[] used = new atom[total];
  for (int i = 0; i < used.length; i++) used[i] = atoms[temp[i]];
  return used;
}

//prints the number of each element to the console
void printCount() {
  println(h, "hydrogens");
  println(c, "carbons");
  println(o, "oxygens");
}

//checks if an atom could be a starting carbon
boolean startingCarbon(atom c) {
  int carbonsBonded = 0; 
  // print("Atom", atoms[used[i]].number, "is bonded to ");
  for (int i = 0; i < c.atomsBonded; i++) {
    if (atoms[c.bonding[0][i]].element == "C") {
      carbonsBonded++;
    }
  }
  if (carbonsBonded <= 1) return true;
  return false;
}

//draws all atoms and their bonds
void display() {
  for (int i = 0; i < bonds.size(); i++) bonds.get(i).display(); 
  for (int i = 0; i < currentAtom; i++) atoms[i].display();
}

void mousePressed() {
  if (mouseButton == LEFT) leftClick(); 
  if (mouseButton == RIGHT) rightClick();
}

void leftClick() {
  if (!clicking) {
    boolean done = false; 
    for (int i = 0; i < currentAtom; i++) {
      if (atoms[i].click(mouseX, mouseY)) {
        done = true; 
        atoms[i].clicked(); 
        clicking = true; 
        atomClicked = i; 
        for (int h = 0; h < newAtoms.length; h++) {
          if (i == newAtoms[h]) {
            atoms[currentAtom] = new atom(atoms[i].element); 
            newAtoms[h] = currentAtom-1;
          }
        }
        i = currentAtom;
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
    atoms[atomClicked].clicked = false; 
    clicking = false;
  }
}

void rightClick() {
  boolean done = false; 
  if (!clicking) {
    for (int i = 0; i < currentAtom; i++) {
      if (atoms[i].click(mouseX, mouseY)) {
        if (atoms[i].bonds < atoms[i].maxBonds) {
          bonds.add(new bond(atoms[i])); 
          atomClicked = i; 
          clicking = true;
        }
        i = currentAtom; 
        done = true;
      }
    }
    if (!done) {
      for (int i = 0; i < bonds.size(); i++) {
        if (bonds.get(i).click(mouseX, mouseY)) {
          bonds.get(i).decrease();
        }
      }
    }
  } else {
    for (int i = 0; i < currentAtom; i++) {
      if (atoms[i].click(mouseX, mouseY) && bonds.get(bonds.size()-1).atom1.number != atoms[i].number) {
        bonds.get(bonds.size()-1).complete(atoms[i]); 
        done = true;
      }
    }
    if (!done) {
      bonds.remove(bonds.size()-1);
    }
    clicking = false;
  }
}

void status() {
  for (int i = 0; i < 2; i++) {
    if (atoms[i].inUse) println("This", atoms[i].element, "is bonded to a", atoms[atoms[i].bonding[0][0]].element);
  }
}

void keyPressed() {
  if (key == ' ') name();
}