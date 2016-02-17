/*
 * welp, this version seems to be the correct way to use the source image's size as the
 * sketch's size according to the processing docs, but it doesn't work ( tested Processing v3.0.2 )
 */

//Christian Attard
//2015 @ introwerks 

PImage img;
String name = "maria"; //file name 
String type = "jpg"; //file type
int count = int(random(666));
color col;
int c;

int space =5; // space between lines
float weight = 1; // line weight
float depth = 0.9; // z depth
int zoom = 100; // zoom image

void setup() {
  size(100,100,P3D);
  surface.setResizable(true);
  img = loadImage(name + "." + type);
  surface.setSize(img.width,img.height);
  background(0);
  println("christian attard, 2015 @ introwerks");

  for (int i = 0; i < img.width; i+=space) {
    beginShape();
    for (int j = 0; j < img.height; j+=space) {
      c = i+(j*img.width);
      col = img.pixels[c];
      stroke(red(col), green(col), blue(col), 255);
      strokeWeight(weight);
      noFill();
      vertex (i, j, (depth * brightness(col))-zoom);
    }
    endShape();
  }

  save(name + "_" + count + "." + type);
  println("done");
  exit();
}