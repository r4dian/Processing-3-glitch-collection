PImage img1;
int w, h;
Boolean debugging = false;

void settings() {
  img1 = loadImage("source.jpg");
  size(w = img1.width, h = img1.height, P3D);
}

void setup() {
  size(100,100,P3D);
  background(0); 
  //image(img1,0,0);
  img1 = loadImage("source.jpg");
  surface.setSize(w = img1.width, h = img1.height);
}

void draw() 
{ 
  background(0);
  drawpicturebox();

  //  rotateY(radians(90));
  int x = (int)map(mouseX,0,width,0,img1.width);
  int y = (int)map(mouseY,0,height,0,img1.height);
  int p = x + y * img1.width;
  save("result.png");
  //stroke(img1.pixels[p]);
  
  //line(mouseX, mouseY, pmouseX, pmouseY);
  exit();
}
void drawpicturebox() { 
 if (debugging) translate(0, 0, -h);
  pushMatrix();
  translate(0, 0, -h);
  image(img1, 0, 0); //deep
  popMatrix();
  
  pushMatrix();
  translate(0,-1,-h-1);
  rotateY(radians(270));
  image(img1, 0, 0); //left
  popMatrix();
  
  pushMatrix();
  translate(0, 0, -h);
  rotateX(radians(90));
  image(img1, 0, 0); //top
  popMatrix();
  
  pushMatrix();
  translate(w-2,0,0);
  rotateY(radians(90));
  image(img1,0,0);//right
  popMatrix();
  
  pushMatrix();
  translate(0,h,0);
  rotateX(radians(270));
  image(img1,0,0);//bottom
  popMatrix();
  
  pushMatrix();

  popMatrix();
  //background(204); 
  println(lerpColor(255, 30, 0.5));


}