atom[] atoms = new atom[99];
ArrayList <bond> bonds = new ArrayList <bond>();
boolean clicking;
int atomClicked;
int currentAtom;
int[] newAtoms = {0, 1, 2};
int c = 0;
int h = 0;
int o = 0;
int doubleBonds;
int checkedDouble;
int tripleBonds;
int checkedTriple;
int current;
int numBranches;
int branchLength;
int[][] branches;
int[] longest;
int orientation = 1;
int[] last;
int[] checked;
atom[] used;
String name = "";
String type = "";
int bondStrength;

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

//draws all atoms and their bonds
void display() {
  for (int i = 0; i < bonds.size(); i++) bonds.get(i).display(); 
  for (int i = 0; i < currentAtom; i++) atoms[i].display();
  fill(0);
  textSize(20);
  text(name, 420-name.length()*5, 600);
}

//names the organic molecule
void name() {
  name = "";
  c = 0;
  h = 0;
  o = 0;

  findType();
  used = findUsed();
  checked = new int[999];
  longest = new int[0];
  last = new int[999];
  for (int i = 0; i < used.length; i++) {
    if (startingCarbon(used[i])) {
      checkedDouble = 0;
      checkedTriple = 0;
      last[0] = used[i].number;
      current = 0;
      checked[current] = used[i].number;
      current++;
      nextCarbon(used[i]);
    }
  }



  //branches(false);
  println();
  //nameBranches();
  nameChain();
  println(name);
  status();
}

void findType() {
  doubleBonds = 0;
  tripleBonds = 0;
  for (int i = 0; i < bonds.size(); i++) {
    if (bonds.get(i).strength == 3) tripleBonds++;
    if (bonds.get(i).strength == 2) doubleBonds++;
  }
  if (tripleBonds > 0) type = "alkyne";
  else if (doubleBonds > 0) type = "alkene";
  else type = "alkane";
}

//returns an array of the carbons in the longest chain in correct order
int[] reorderCarbons(int branch) {
  int[] chain = new int[longest.length];
  int rightDistance = 0;
  int leftDistance = longest.length;
  if (type == "alkene") {
    for (int i = 0; i < bonds.size(); i++) {
    }
  }
  for (int i = 0; i < numBranches; i++) {
    if (branches[1][i] == branch) {
      if (longest.length-1-branches[0][i] > rightDistance) rightDistance = longest.length-1-branches[0][i];
      if (branches[0][i] < leftDistance) leftDistance = branches[0][i];
    }
  }
  if (leftDistance > rightDistance) {
    for (int i = 0; i < longest.length; i++) chain[i] = longest[longest.length-1-i];
    return chain;
  } else if (leftDistance == rightDistance) {
    for (int i = 0; i < numBranches; i++) {
      if (branches[1][i] == 2) {
        i = numBranches;
        return reorderCarbons(2);
      }
      if (branches[1][i] == 1) {
        i = numBranches;
        chain = reorderCarbons(1);
        return chain;
      }
      if (branches[1][i] == 3) {
        i = numBranches;
        chain = reorderCarbons(3);
        return reorderCarbons(3);
      }
    }
  }
  return longest;
}

void nameBranches() {
  int[] branchNames = new int [10]; 
  for (int i = 0; i < numBranches; i++) {
    branchNames[branches[1][i]]++;
  }
  boolean firstBranch = true; 
  if (branchNames[4] > 0) {
    if (!firstBranch) print("-"); 
    firstBranch = false; 
    boolean first = true;
    for (int i = 0; i < numBranches; i++) {
      if (branches[1][i] == 4) {
        if (!first) name+=(",");
        name+=(branches[0][i]+1);
        first = false;
      }
    }
    String prefix = prefix(branchNames[4]); 
    name+=("-"+prefix); 
    name+=("butyl");
  }
  if (branchNames[2] > 0) {
    if (!firstBranch) name+=("-"); 
    firstBranch = false; 
    boolean first = true; 
    for (int i = 0; i < numBranches; i++) {
      if (branches[1][i] == 2) {
        if (!first) name+=(",");
        name+=(branches[0][i]+1);
        first = false;
      }
    } 
    String prefix = prefix(branchNames[2]); 
    name+=("-"+prefix); 
    name+=("ethyl");
  }
  if (branchNames[1] > 0) {
    if (!firstBranch) name+=("-"); 
    firstBranch = false; 
    boolean first = true;
    for (int i = 0; i < numBranches; i++) {
      if (branches[1][i] == 1) {
        if (!first) name+=(",");
        name+=(branches[0][i]+1);
        first = false;
      }
    }
    String prefix = prefix(branchNames[1]); 
    name+=("-"+prefix); 
    name+=("methyl");
  }
  if (branchNames[3] > 0) {
    if (!firstBranch) name+=("-"); 
    firstBranch = false; 
    boolean first = true;
    for (int i = 0; i < numBranches; i++) {
      if (branches[1][i] == 3) {
        if (!first) name+=(",");
        name+=(branches[0][i]+1);
        first = false;
      }
    }
    String prefix = prefix(branchNames[3]); 
    name+=("-"+prefix); 
    name+=("propyl");
  }
}

String prefix(int num) {
  switch(num) {
  case 2: 
    return "di"; 
  case 3: 
    return "tri";
  case 4:
    return "tetra";
  case 5:
    return "penta";
  case 6:
    return "hexa";
  case 7:
    return "hepta";
  case 8: 
    return "octa";
  }
  return "";
}

void branches(boolean orderedCarbons) {
  boolean butyl = false;
  boolean ethyl = false;
  boolean methyl = false;
  boolean propyl = false;
  numBranches = 0; 
  branches = new int[2][10]; 
  for (int i = 0; i < longest.length; i++) {
    if (atoms[longest[i]].carbonsBonded > 2) {
      for (int j = 0; j < atoms[longest[i]].atomsBonded; j++) {
        boolean branch = false; 
        if (i > 0 && i < longest.length-1) {
          if (atoms[longest[i]].bonding[0][j] != longest[i-1] && atoms[longest[i]].bonding[0][j] != longest[i+1]) branch = true;
        } else if (i > 0) {
          if (atoms[longest[i]].bonding[0][j] != longest[i-1]) branch = true;
        } else if (i < longest.length-1) {
          if (atoms[longest[i]].bonding[0][j] != longest[i+1]) branch = true;
        }
        if (branch) {
          branchLength = 1; 
          branches[0][numBranches] = i; 
          nextBranch(atoms[atoms[longest[i]].bonding[0][j]], atoms[longest[i]].number); 
          branches[1][numBranches] = branchLength; 
          if (branchLength == 1) methyl = true;
          if (branchLength == 2) ethyl = true;
          if (branchLength == 3) propyl = true;
          if (branchLength == 4) butyl = true;
          numBranches++;
        }
      }
    }
  }
  if (!orderedCarbons) {
    if (butyl) longest = reorderCarbons(4);
    else if (ethyl) longest = reorderCarbons(2);
    else if (methyl) longest = reorderCarbons(1);
    else if (propyl) longest = reorderCarbons(3);
    branches(true);
  }
}

void nextBranch(atom c, int last) {
  for (int i = 0; i < c.atomsBonded; i++) {
    if (atoms[c.bonding[0][i]].element == "C" && c.bonding[0][i] != last) {
      branchLength++; 
      nextBranch(atoms[c.bonding[0][i]], c.number);
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
      if (type == "alkene" && c.bonding[1][i] == 2) {
        nextCarbon(atoms[c.bonding[0][i]]);
        checkedDouble++;
      }
      if (type == "alkyne" && c.bonding[1][i] == 3) {
        nextCarbon(atoms[c.bonding[0][i]]);
        checkedTriple++;
      }
      nextCarbon(atoms[c.bonding[0][i]]);
    }
  }
  if (current > longest.length) {
    if (!multiLevelBranching()) {
      if (type == "alkane") {
        longest = new int[current]; 
        for (int i = 0; i < current; i++) longest[i] = checked[i];
      }
      if (type == "alkene" && checkedDouble == doubleBonds) {
        longest = new int[current]; 
        for (int i = 0; i < current; i++) longest[i] = checked[i];
      }
      if (type == "alkyne" && checkedTriple == tripleBonds) {
        longest = new int[current]; 
        for (int i = 0; i < current; i++) longest[i] = checked[i];
      }
    }
  }
  current--;
}

//finds if there are branches with branches
boolean multiLevelBranching() {
  for (int i = 0; i < used.length; i++) {
    boolean included = false; 
    for (int j = 0; j < current; j++) {
      if (used[i].number == checked[j]) included = true;
    }
    if (!included && used[i].carbonsBonded > 2) return true;
  }
  return false;
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
  println(doubleBonds, "double bonds");
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
  if (c.carbonsBonded <= 1) return true; 
  return false;
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
  /*for (int i = 0; i < 2; i++) {
   if (atoms[i].inUse) println("This", atoms[i].element, "is bonded to a", atoms[atoms[i].bonding[0][0]].element);
   }*/

  println("Longest chain is", longest.length, "long");
  println("It is comprised of ");
  for (int i = 0; i < longest.length; i++) print(longest[i]);
  println();
  println("There are", numBranches, "branches");
  for (int i = 0; i < numBranches; i++) println(branches[1][i], "long branch starting at", branches[0][i]);
  println();
}


void nameChain() {
  if (type == "alkane") {
    switch(longest.length) {
    case 1: 
      name+=("methane");
      break;
    case 2: 
      name+=("ethane");
      break;
    case 3: 
      name+=("propane");
      break;
    case 4: 
      name+=("butane");
      break;
    case 5: 
      name+=("pentane");
      break;
    case 6: 
      name+=("hexane");
      break;
    case 7: 
      name+=("heptane");
      break;
    case 8: 
      name+=("octane");
      break;
    case 9:
      name+=("nonane");
      break;
    case 10:
      name+=("decane");
      break;
    case 11:
      name+="undecane";
      break;
    case 12:
      name+="dodecane";
      break;
    case 13:
      name+="tridecane";
      break;
    case 14:
      name+="tetradecane";
      break;
    case 15:
      name+="pentadecane";
      break;
    }
  }
}

void keyPressed() {
  if (key == ' ') name();
  if (!clicking) {
    if (key == 'c') {
      atomClicked = currentAtom;
      atoms[currentAtom] = new atom("C");
      atoms[currentAtom-1].move(mouseX, mouseY);
      atoms[currentAtom-1].clicked = true;
      clicking = true;
    }
  }
}