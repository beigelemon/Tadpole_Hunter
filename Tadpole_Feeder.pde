//I'm making a modernized snake game but you're a tadpole eating smaller tadpoles and you grow as youe at.

ArrayList<Trail> trails = new ArrayList<Trail>(); //storing previous position of tadpole tail
float mainSize = 40; // Initial body size of the tadpole body
PVector direction; //stores the direction the tadpole is going
ArrayList<Food> foodItems;
int score = 0;
boolean gameWon = false; //will turn true when all of the Stadpoles are eaten
PFont myFont;

void setup() {
  size(1000, 1000);
  myFont = createFont("game_over.ttf", 56);  // Replace with your font file name
  textFont(myFont);
  background(255);
  direction = new PVector(1, 0); //first direction of movement
  foodItems = new ArrayList<Food>(); //
  for (int i = 0; i < 20; i++) { //creates my small tadpoles
    foodItems.add(new Food()); //
  }
}

void draw() {
  background(206, 247, 215, 20); // Slight fade effect to gradually remove tadpole tail ends
  
  if (gameWon) { //writing you won!
    fill(255, 0, 0); 
    textSize(100);
    text("You Won!", width / 2 -100, height / 2); // center the wordss
    return; // returns true or false
  }
  

  PVector mouse = new PVector(mouseX, mouseY); //create a new vector calculating my mouse position
  direction = PVector.sub(mouse, new PVector(trails.isEmpty() ? width / 2 : trails.get(0).x, // if there are no trails, it starts from the middle of the screen
                                               trails.isEmpty() ? height / 2 : trails.get(0).y)); // if not it takes the first position of my tadpole head
  direction.normalize().mult(5); //normalize my vector to keep only lenght not speed.
  
  trails.add(new Trail(mouseX, mouseY)); //tail effect by adding a new trail
  
  for (int i = trails.size() - 1; i >= 0; i--) { //loops through all trail segments to update each one
    Trail t = trails.get(i);
    t.update(i); // adds one
    t.display();
    if (t.isFaded()) {
      trails.remove(i); //removes the trails
    }
  }
  

  fill(0);
  noStroke();
  ellipse(mouseX, mouseY, mainSize, mainSize); //my tadpole head
  

  for (int i = foodItems.size() - 1; i >= 0; i--) {
    Food f = foodItems.get(i);
    f.move(); // moves my food particles
    f.display(); // shows my food particles
    if (dist(mouseX, mouseY, f.pos.x, f.pos.y) < f.size) { // checks if tadpole has overlapped with food
      mainSize += f.size * 0.5; // tadpole gets bigger as it eats
      score += 5; // each food is 5 points
      foodItems.remove(i); // remove when eaten
    }
  }
  
  if (foodItems.isEmpty()) { // if all food is gone, 
    gameWon = true; // game is won
  }
  
  fill(255, 0, 0);
  textSize(56);
  text("Score: " + score, 10, 28);
}

class Trail { // my trail class (so basically my tadpole class since my tadpole is mostly made up of trails 
  float x, y;
  float size;
  int alpha; //opacity when fading

// constructor
  Trail(float x, float y) {
    this.x = x;
    this.y = y;
    this.size = mainSize * 0.8; // trails are started at %80 of my head size
    this.alpha = 255; //full colour
  }

  void update(int index) {
    size *= 0.95; //they shirnk slowly
    alpha -= 5; // they fade slowly
    size -= index * 0.02; // older ones shrink faster
  }

  void display() {
    fill(0, alpha); //drawing my trails with fade efefct
    noStroke();
    ellipse(x, y, max(size, 5), max(size, 5));
  }

  boolean isFaded() {
    return alpha <= 0 || size <= 5; // trails dissapear when they get below a certain size
  }
}

class Food {
  PVector pos; //position of the food
  int size; //size of the food
  PVector speed; //movement speed and direction

  Food() {
    pos = new PVector(random(width), random(height)); //randomly appears somewhere on the screen
    size = int(random(10, 25)); // randomly sized
    speed = PVector.random2D().mult(2); //randomyly moves in a random direction
  }

  void move() {
    pos.add(speed);
    if (pos.x < 0 || pos.x > width) speed.x *= -1; // bounces off the walls to stay in canvas
    if (pos.y < 0 || pos.y > height) speed.y *= -1;
  }

  void display() {
    fill(0);
    ellipse(pos.x, pos.y, size, size);
  }
}
