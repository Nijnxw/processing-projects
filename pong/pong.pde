final int THICC = 20;
final float DEF_MOV_SPD = 50;

class Ball {
  private int x, y, size;
  private double vel_x, vel_y, spd_multi;
  
  public Ball(int x, int y) {
     this.x = x;
     this.y = y;
     vel_x = DEF_MOV_SPD / 2;
     vel_y = DEF_MOV_SPD / 2;
     size = THICC;
     spd_multi = 1.25;
  }
   
  public int getX() {
    return x;
  }
   
  public int getY() {
    return y;
  }
  
  public double getVelX() {
    return vel_x;
  }
   
  public double getVelY() {
    return vel_y;
  }
  
  public int getRadius() {
    return size / 2;
  }
   
  public void setX(int x) {
    this.x = x;
  }
   
  public void setY(int y) {
    this.y = y;
  }
  
  public void setVelX(double x) {
    vel_x = x * spd_multi;
  }
   
  public void setVelY(double y) {
    vel_y = y * spd_multi;
  }
  
  public void setRadius(int radius) {
    size = radius * 2;
  }
  
  public void display() {
    rectMode(CENTER);
    noStroke();
    fill(255);
    rect(x, y, size, size);
  }
  
  public void move(double dt, Board b_left, Board b_right) {
    if ((y + (vel_y * dt)) + (size / 2) > height || (y + (vel_y * dt)) - (size / 2) < 0) {
      vel_y = -vel_y;
    }
    
    if ((x + (vel_x * dt)) - (size / 2) > width) { // ball going off the right side of the screen
      score_left = score_left + 1;
      b_left.setY(height / 2);
      b_right.setY(height / 2);
      reset();
    } else if ((x + (vel_x * dt)) + (size / 2) < 0) { // ball going off the left side of the screen
      score_right = score_right + 1;
      b_left.setY(height / 2);
      b_right.setY(height / 2);
      reset();
    }
    
    x += vel_x * dt;
    y += vel_y * dt;
  }
  
  public void reset() {
    x = width / 2;
    y = height / 2;
    vel_x = DEF_MOV_SPD / 2;
    vel_y = DEF_MOV_SPD / 2;
  }
}

class Board {
  private int x, y,board_width, board_height;
  private char key_up, key_down, key_reset;
  private boolean key_up_pressed, key_down_pressed;
  private double vel_x, vel_y, mov_spd;
  
  public Board(int x, int y, char key_up, char key_down, char key_reset) {
     this.x = x;
     this.y = y;
     this.key_up = key_up;
     this.key_down = key_down;
     this.key_reset = key_reset;
     board_width = THICC;
     board_height = THICC * 8;
     vel_x = 0;
     vel_y = 0;
     mov_spd = DEF_MOV_SPD;
  }
   
  public int getX() {
    return x;
  }
   
  public int getY() {
    return y;
  }
  
  public double getVelX() {
    return vel_x;
  }
   
  public double getVelY() {
    return vel_y;
  }
   
  public void setX(int x) {
    this.x = x;
  }
   
  public void setY(int y) {
    this.y = y;
  }
  
  public void setVelX(int x) {
    vel_x = x;
  }
   
  public void setVelY(int y) {
    vel_y = y;
  }
  
  public boolean checkCollision(Ball ball, double dt) {
    boolean collided = false, collide_x = false, collide_y = false;
    
    int ball_x = ball.getX() + (int) (ball.getVelX() * dt);
    int ball_y = ball.getY() + (int) (ball.getVelY() * dt);
    int ball_radius = ball.getRadius();
    
    if (x > ball_x) { // ball approaching from the left
      if ((x + (board_width / 2)) - (ball_x - ball_radius)
          < (board_width + (ball_radius * 2)) ) {
        collide_x = true;
      }
    } else { // ball approaching from the right
      if ((ball_x + ball_radius) - (x - (board_width / 2))
          < (board_width + (ball_radius * 2)) ) {
        collide_x = true;
      }
    }
    
    
   if (y > ball_y) { // ball approaching from above
      if ((y + (board_height / 2)) - (ball_y - ball_radius)
          < (board_height + (ball_radius * 2)) ) {
        collide_y = true;
      }
    } else { // ball approaching from below
      if ((ball_y + ball_radius) - (y - (board_height / 2))
          < (board_height + (ball_radius * 2)) ) {
        collide_y = true;
      }
    }
    
    if (collide_x && collide_y) {
      collided = true;
      boolean collided_sides, collided_top;
      
      if (ball_y <  y + (board_height / 2)
        && ball_y >  y - (board_height / 2)) { //if the center of the ball is between the sides of the board
        collided_sides = true;
      } else {
        collided_sides = false;
      }
      
      if (ball_x <  x + (board_width / 2)
        && ball_x >  x - (board_width / 2)) { //if the center of the ball is between the top/bottom of the board
        collided_top = true;
      } else {
        collided_top = false;
      }
      
      if (collided_sides && !collided_top) { //collide from left/right
        ball.setVelX(-ball.getVelX());
        println("collided on the sides");
      } else if (!collided_sides && collided_top) { //collide from top/bottom
        ball.setVelY(-ball.getVelY());
        println("collided on the top/bottom");
      } else if (!collided_sides && !collided_top) { //collide from corners
        ball.setVelX(-ball.getVelX());
        ball.setVelY(-ball.getVelY());
      } else { // collides too fast into board
        ball.setVelX(-ball.getVelX());
      }
    }
    
    return collided;
  }
  
  public void checkKeyPressed(char _key) {
    if (_key == key_up) {
      key_up_pressed = !key_up_pressed;
    } else if (_key == key_down) {
      key_down_pressed = !key_down_pressed;
    } else if (_key == key_reset) {
      key_up_pressed = false;
      key_down_pressed = false;
    }
  }
  
  public void display() {
    rectMode(CENTER);
    noStroke();
    fill(255);
    rect(x, y, board_width, board_height);
  }
  
  public void move(double dt) {
    if (key_up_pressed && key_down_pressed || !key_up_pressed && !key_down_pressed) {
      vel_y = 0;
    } else if (key_up_pressed) {
      vel_y = -mov_spd;
    } else {
      vel_y = mov_spd;
    }
    
    if ((y + (vel_y * dt)) + (board_height / 2) < height && (y + (vel_y * dt)) - (board_height / 2) > 0) {
      x += vel_x * dt;
      y += vel_y * dt;
    }
      
  }
}

long prev = 0;
static int score_left = 0, score_right = 0;
double delta;
boolean first_time_start = true;
Ball ball;
Board board_left, board_right;

void setup() {
  textFont(createFont("Comic Sans MS Bold", 156));
  
  size(1200, 800);
  
  ball = new Ball(width / 2, height / 2);
  board_left = new Board(THICC, height / 2, 'w', 's', 'x');
  board_right = new Board(width - THICC, height / 2, 'o', 'l', '.');
}

void draw() {
  clear();
  background(0);
  drawDottedLine(8);
  drawScore(score_left, score_right, 200);
  
  if (first_time_start) {
    delta = (-prev + (prev = frameRateLastNanos)) / 1e8d;
    first_time_start = false;
    println(delta);
  }
  
  delta = (-prev + (prev = frameRateLastNanos)) / 1e8d;
  
  ball.move(delta, board_left, board_right);
  ball.display();
  
  board_left.move(delta);
  board_left.display();
  board_left.checkCollision(ball, delta);
  
  board_right.move(delta);
  board_right.display();
  board_right.checkCollision(ball, delta);
}

void keyPressed() {
  board_left.checkKeyPressed(key);
  board_right.checkKeyPressed(key);
}

void keyReleased() { 
  board_left.checkKeyPressed(key);
  board_right.checkKeyPressed(key);
}

void drawDottedLine(int totalLines) {
  int freq = totalLines * 2;
  int offset = (height / totalLines) / 4;
  strokeCap(SQUARE);
  strokeWeight(THICC);
  stroke(255);
  
  push();
  translate(0, offset);
  
  for(float i = 0; i < freq; i = i + 2) {
    line(width/2, lerp(0, height, i / freq),
         width/2, lerp(0, height, (i + 1) / freq));
  }
  
  pop();
}

void drawScore(int score_left, int score_right, int offset_top) {
  textSize(156);
  textAlign(CENTER);
  fill(255);
  
  text(score_left, width / 4, offset_top);
  
  text(score_right, (3 * width) / 4, offset_top);
}
