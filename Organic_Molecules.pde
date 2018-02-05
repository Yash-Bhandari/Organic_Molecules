atom[] atoms = new atom[99]; //<>// //<>//
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
int firstDouble;
int tripleBonds;
int checkedTriple;
int firstTriple;
int current;
int numBranches;
int branchLength;
int[][] branches;
int[][] multiBonds;
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
  fill(0);
  if (clicking) text("clicking", 100, 600);
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
  multiBonds = new int[2][999];
  longest = new int[0];
  last = new int[999];
  for (int i = 0; i < used.length; i++) {
    if (startingCarbon(used[i])) {
      println();
      checkedDouble = 0;
      checkedTriple = 0;
      firstDouble = used.length;
      firstTriple = used.length;
      last[0] = used[i].number;
      current = 0;
      checked[current] = used[i].number;
      current++;
      nextCarbon(used[i]);
    }
  }

  branches(false);
  nameBranches();
  nameChain();
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
int[] reorderCarbons(int branchType) {
  int[] chain = new int[longest.length];
  findMultiBonds();
  int rightDistance = 0;
  int leftDistance = longest.length;
  int numBonds = 0;
  if (type == "alkene") numBonds = doubleBonds;
  if (type == "alkyne") numBonds = tripleBonds;

  if (branchType != 100) {
    for (int i = 0; i < numBranches; i++) {
      if (branches[1][i] == branchType) {
        if (longest.length-1-branches[0][i] > rightDistance) rightDistance = longest.length-1-branches[0][i];
        if (branches[0][i] < leftDistance) leftDistance = branches[0][i];
      }
    }
  } else if (branchType == 100) {
    leftDistance = numBonds;
    for (int i = 0; i < numBonds; i++) {
      if (numBonds-1-multiBonds[1][i] > rightDistance) rightDistance = numBonds-1-multiBonds[1][i];
      if (multiBonds[1][i] < leftDistance) leftDistance = multiBonds[1][i];
    }
  }
  if (leftDistance > rightDistance) {
    for (int i = 0; i < longest.length; i++) chain[i] = longest[longest.length-1-i];
    if (type == "alkene" || type == "alkyne") findMultiBonds();
    return chain;
  } else if (leftDistance == rightDistance) {
    for (int i = 0; i < numBranches; i++) {
      if (branches[1][i] == 2 && branchType != 2) {
        i = numBranches; 
        return reorderCarbons(2);
      }
      if (branches[1][i] == 7 && branchType != 7) {
        i = numBranches; 
        chain = reorderCarbons(7); 
        return chain;
      }
      if (branches[1][i] == 6 && branchType != 6) {
        i = numBranches; 
        chain = reorderCarbons(6); 
        return chain;
      }
      if (branches[1][i] == 1 && branchType != 1) {
        i = numBranches; 
        chain = reorderCarbons(1); 
        return chain;
      }
      if (branches[1][i] == 5 && branchType != 5) {
        i = numBranches; 
        chain = reorderCarbons(5); 
        return chain;
      }
      if (branches[1][i] == 3 && branchType != 3) {
        i = numBranches; 
        chain = reorderCarbons(3); 
        return chain;
      }
    }
  }
  return longest;
}

//finds the location of all multiple bonds and stores it in multiBonds[1][]
void findMultiBonds () {
  int counter = 0;
  int bondStrength = 0;
  if (type == "alkene") bondStrength = 2;
  if (type == "alkyne") bondStrength = 3;
  for (int i = 0; i < longest.length; i++) {
    for (int j = 0; j < atoms[longest[i]].atomsBonded; j++) {
      if (i == 0) {
        if (atoms[longest[i]].bonding[1][j] == bondStrength) {
          multiBonds[1][counter] = i;
          counter++;
        }
      } else {
        if (atoms[longest[i]].bonding[1][j] == bondStrength && atoms[longest[i]].bonding[0][j] != longest[i-1]) {
          multiBonds[1][counter] = i;
          counter++;
        }
      }
    }
  }
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
  case 2 : 
    return "di"; 
  case 3 : 
    return "tri"; 
  case 4 : 
    return "tetra"; 
  case 5 : 
    return "penta"; 
  case 6 : 
    return "hexa"; 
  case 7 : 
    return "hepta"; 
  case 8 : 
    return "octa";
  }
  return "";
}

void branches(boolean orderedCarbons) {
  boolean butyl = false; 
  boolean ethyl = false; 
  boolean methyl = false; 
  boolean propyl = false; 
  boolean pentyl = false; 
  boolean hexyl = false; 
  boolean heptyl = false; 
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
          if (branchLength == 5) pentyl = true; 
          if (branchLength == 6) hexyl = true; 
          if (branchLength == 7) heptyl = true; 
          numBranches++;
        }
      }
    }
  }
  if (!orderedCarbons) {
    if (type == "alkene" || type == "alkyne") longest = reorderCarbons(100); 
    else if (butyl) longest = reorderCarbons(4); 
    else if (ethyl) longest = reorderCarbons(2); 
    else if (heptyl) longest = reorderCarbons(7); 
    else if (hexyl) longest = reorderCarbons(8); 
    else if (methyl) longest = reorderCarbons(1); 
    else if (pentyl) longest = reorderCarbons(5); 
    else if (propyl) longest = reorderCarbons(3); 
    branches(true);
  }
}

//recursive function that will run through a branch to determine it's length in the variable branchLength
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
      if (type == "alkene" && c.bonding[1][i] == 2) {
        multiBonds[0][checkedDouble] = current; 
        checkedDouble++; 
        current++; 
        nextCarbon(atoms[c.bonding[0][i]]);
      } else if (type == "alkyne" && c.bonding[1][i] == 3) {
        multiBonds[0][checkedTriple] = current; 
        checkedTriple++; 
        current++; 
        nextCarbon(atoms[c.bonding[0][i]]);
      } else {
        current++; 
        nextCarbon(atoms[c.bonding[0][i]]);
      }
    }
  }
  if (current > longest.length && !multiLevelBranching()) {
    if (type == "alkane") {
      longest = new int[current]; 
      for (int i = 0; i < current; i++) longest[i] = checked[i];
    }
    if (type == "alkene" && checkedDouble == doubleBonds) {
      for (int i = 0; i < current; i++) {
        for (int j = 0; j < atoms[checked[i]].atomsBonded; j++) {
          if (atoms[checked[i]].bonding[1][j] == 2) {
            if (i < firstDouble) {
              firstDouble = i; 
              longest = new int[current]; 
              for (int k = 0; k < current; k++) longest[k] = checked[k]; 
              for (int k = 0; k < doubleBonds; k++) multiBonds[1][k] = multiBonds[0][k];
            }
            j = atoms[checked[i]].atomsBonded; 
            i = current;
          }
        }
      }
    }
    if (type == "alkyne" && checkedTriple == tripleBonds) {
      for (int i = 0; i < current; i++) {
        for (int j = 0; j < atoms[checked[i]].atomsBonded; j++) {
          if (atoms[checked[i]].bonding[1][j] == 3) {
            if (i < firstTriple) {
              firstTriple = i; 
              longest = new int[current]; 
              for (int k = 0; k < current; k++) longest[k] = checked[k]; 
              for (int k = 0; k < tripleBonds; k++) multiBonds[1][k] = multiBonds[0][k];
            }
            j = atoms[checked[i]].atomsBonded; 
            i = current;
          }
        }
      }
    }
  }
  for (int i = 0; i < c.atomsBonded; i++) {
    if (c.bonding[1][i] == 2) checkedDouble--; 
    if (c.bonding[1][i] == 3) checkedTriple--;
  }
  current--;
}

//adds the numbers of the carbons that have multiple bonds to the name
//ex: (hex)-3,4-di(ene)
void nameMultiBonds() {
  int limit; 
  boolean first = true; 
  if (doubleBonds > 1 || tripleBonds > 1) name+="a"; 
  if (doubleBonds > tripleBonds) limit = doubleBonds; 
  else limit = tripleBonds; 
  for (int i = 0; i < limit; i++) {
    if (first) name+="-"; 
    if (!first) name+=", "; 
    name+=multiBonds[1][i]; 
    first = false;
  }
  if (type == "alkene") name+="-"+prefix(doubleBonds); 
  if (type == "alkyne") name+="-"+prefix(tripleBonds);
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
  println(longest.length); 
  switch(longest.length) {
  case 1 : 
    name+=("meth"); 
    break; 
  case 2 : 
    name+=("eth"); 
    break; 
  case 3 : 
    name+=("prop"); 
    break; 
  case 4 : 
    name+=("but"); 
    break; 
  case 5 : 
    name+=("pent"); 
    break; 
  case 6 : 
    name+=("hex"); 
    break; 
  case 7 : 
    name+=("hept"); 
    break; 
  case 8 : 
    name+=("oct"); 
    break; 
  case 9 : 
    name+=("non"); 
    break; 
  case 10 : 
    name+=("dec"); 
    break; 
  case 11 : 
    name+="undec"; 
    break; 
  case 12 : 
    name+="dodec"; 
    break; 
  case 13 : 
    name+="tridec"; 
    break; 
  case 14 : 
    name+="tetradec"; 
    break; 
  case 15 : 
    name+="pentadec"; 
    break;
  }
  if (type == "alkene" || type == "alkyne") nameMultiBonds(); 
  switch(type) {
  case "alkane" : 
    name+="ane"; 
    break; 
  case "alkene" : 
    name+="ene"; 
    break; 
  case "alkyne" : 
    name+="yne"; 
    break;
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