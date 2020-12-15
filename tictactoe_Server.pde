//Server (sends x's (2))
import processing.net.*;

color green = #88C100;
color red = #FF003C;
boolean myTurn = true;

Server myServer;
int[][] grid;

void setup() {
  size(300, 400);
  grid = new int[3][3];
  strokeWeight(3);
  textAlign(CENTER, CENTER);
  textSize(50);
  myServer = new Server(this, 1234);
}

void draw() {
  if (myTurn) 
  background(green);
  else 
  background(red);

  //draw dividing lines
  stroke(0);
  line(0, 100, 300, 100);
  line(0, 200, 300, 200);
  line(100, 0, 100, 300);
  line(200, 0, 200, 300);

  //draw the x's and o's
  for (int r = 0; r < 3; r++) {
   for (int c = 0; c < 3; c++) {
     drawXO(r, c);
   }
 }

  //draw mouse coords
  fill(0);
  text(mouseX + "," + mouseY, 150, 350);
  //incoming moves
  Client myclient = myServer.available();
  if (myclient != null) {
    String incoming = myclient.readString();
    int r = int(incoming.substring(0,1));
    int c = int(incoming.substring(2,3));
    grid[r][c] = 1;
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
  } else if (grid[row][col] == 2) {
    line (15, 15, 85, 85);
    line (85, 15, 15, 85);
  }
  popMatrix();
}


void mouseReleased() {
  //assign the clicked-on box with the current player's mark
  int row = (int)mouseX/100;
  int col = (int)mouseY/100;
  if (myTurn && grid[row][col] == 0) {
    myServer.write(row + "," + col);
    grid[row][col] = 2;
    println(row + "," + col);
    myTurn = false;
  }
}
