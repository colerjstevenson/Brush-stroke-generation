boolean rand = true;


float x1, y1, x2, y2, x3, y3, x4, y4;
color col;
int counter = 25;
float strokeWidth = 5;
float maxStrokeLength = 2;
int bristleCount = 6;
float bristleThickness = 8;

float mr = 10;
float spikeRate = 80;
float spikedMutation = 25;


int maxDots = 10;
int maxDotSize = 5;
int dotJiggle = 10;

float base = 7;
int numCol = 2;

PImage img;

void setup() {  
  
  
  background(255);
  
  if(rand){
    colorMode(HSB, 100);
    strokeWidth = 70;
    maxStrokeLength = 70;
    bristleCount = 10;//int(random(0, 10));
    bristleThickness = 70;
    
    
    
    spikedMutation = random(0, 5);


    maxDots = 10;
    maxDotSize = 5;
    dotJiggle = 10; 
  }
  
  //source image. Add your own here.
  img = loadImage("mm.jpg");
  img.filter(ERODE);
  
  img.filter(POSTERIZE, 5);
  //image(img, 0, 0);
  
  size(968, 967); // set size to the size of your source image

  initNewStroke();
}

void initNewStroke() {
  // select random start point for new brushstroke
  x1 = random(width);
  y1 = random(height);

  // get color of brushstroke for that location
  col = img.get(int(x1), int(y1));
  
  if(rand){
    col = getCol();
  }
  
  
  float sLength = abs(randomGaussian() * maxStrokeLength);

  //offset bezier points by some small amount
  x2 = x1 + random(-sLength, sLength);
  y2 = y1 + random(-sLength, sLength);
  x3 = x1 + random(-sLength, sLength);
  y3 = y1 + random(-sLength, sLength);
  x4 = x1 + random(-sLength, sLength);
  y4 = y1 + random(-sLength, sLength);
}

int frame = 0;
void draw() {
  for(int i = 0; i < 90-maxStrokeLength; i++){
    noFill();
    stroke(col, 64); // add alpha for painterly look
    if(rand){
      col = randMutate(getCol());
    }else{
      col = mutateColor(col); // slightly mutate the color of each bristle
    }
    bristleThickness = random(1, 4);
    strokeWeight(bristleThickness);
    bezier(x1, y1, x2, y2, x3, y3, x4, y4);
  
    // random walk bezier points
    x1 += random(-strokeWidth, strokeWidth);
    y1 += random(-strokeWidth, strokeWidth);
    x2 += random(-strokeWidth, strokeWidth);
    y2 += random(-strokeWidth, strokeWidth);
    x3 += random(-strokeWidth, strokeWidth);
    y3 += random(-strokeWidth, strokeWidth);
    x4 += random(-strokeWidth, strokeWidth);
    y4 += random(-strokeWidth, strokeWidth);
    
    dots();
  
    // after so many bristles, reset brushstroke
    counter++;
    if (counter % bristleCount == 0) {
      initNewStroke();
    }
    
   
  }
  
  if(mousePressed){
    save("love 1.png");   
  }
  
  if(maxStrokeLength > 1){
    maxStrokeLength -= 0.2;
  }
  if(bristleThickness > 1){
    bristleThickness -= 0.1;
  }
  if(strokeWidth > 1){
    strokeWidth -= 0.1;
  }
  
  
  String name = "mm4";
  
  if(frame > 99){
     save("output/"+ name + "/" +frame+".png");
   }else if(frame >9){
     save("output/"+ name + "/0"+frame+".png");
   }else{
     save("output/"+ name + "/00"+frame+".png");  
   }
  frame++;
  
}

color mutateColor(color c) {
  if(random(0, 100) > spikeRate || rand){
    mr = spikedMutation; // mutation rate
  }
  
  float r = red(c);
  float g = green(c);
  float b = blue(c);

  r += random(-mr, mr);
  r = constrain(r, 0, 255);
  g += random(-mr, mr);
  g = constrain(g, 0, 255);
  b += random(-mr, mr);
  b = constrain(b, 0, 255);
  return color(r, g, b);
}

void dots(){
  int n = int(random(0, maxDots));
  fill(col, 64);
  strokeWeight(0);
  for(int i = 0; i < n; i++){
      ellipse(random(x1, x4) + random(-dotJiggle, dotJiggle), random(y1, y4)+ random(-dotJiggle, dotJiggle), random(0, maxDotSize), random(0, maxDotSize));
  }
  
}

color getCol(){
  int shift = int(round(random(0,numCol)));
  
  float c  = base + shift*(100/numCol) + random (-5, 5);
  if(c < 0){
    c += 100;
  }else if( c > 100){
    c -= 100;
  }
  
  return color(c, random(70,100), random(0, 100));
}

color randMutate(color c){
  
  float h = hue(getCol());
  float s = random(90, 100);
  float b = map(brightness(img.get(int(x1), int(y1))), 0, 100, random(0, 20), 100);

 
 
 
  return color(h, s, b);
  
}
