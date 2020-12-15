//Cleint - 1's (o's)
import processing.net.*;

color green = #88C100;
color red = #FF003C;
boolean myTurn = false;

Client myClient;
int[][] grid;

//r c
void setup() {
  size(300, 400);
  grid = new int[3][3];
  strokeWeight(3);
  textAlign(CENTER, CENTER);
  textSize(50);
  myClient = new Client(this, "127.0.0.1", 1234);
}


void draw() {
   if (myTurn) 
  background(green);
  else 
  background(red);

  //dividing lines
  stroke(0);
  line(0, 100, 300, 100);
  line(0, 200, 300, 200);
  line(100, 0, 100, 300);
  line(200, 0, 200, 300);

  //draw x + os
 for (int r = 0; r < 3; r++) {
   for (int c = 0; c < 3; c++) {
     drawXO(r, c);
   }
 }

  //drawMouseCoords
  fill(0);
  text(mouseX + "," + mouseY, 150, 350);
  //recieveing turns
  if (myClient.available() > 0) {
    String incoming = myClient.readString(); 
    int r = int(incoming.substring(0, 1));
    int c = int(incoming.substring(2, 3));
    grid[r][c] = 2;
    myTurn = true;
  }
}

void drawXO(int row, int col) {
  pushMatrix();
  translate(row*100, col*100);
  if (grid[row][col] == 1) {
    if (myTurn)
    fill(green);
    else fill(red);
    ellipse(50, 50, 80, 80);
  }
  if (grid[row][col] == 2) {
    line (15, 15, 85, 85);
    line(85, 15, 15, 85);
  }
  popMatrix();
}

void mouseReleased() {
  int row = mouseX/100;
  int col = mouseY/100;
  if (myTurn && grid[row][col] == 0) {
    grid[row][col] = 1;
    myClient.write(row + "," + col);
    myTurn = false;
}
}
