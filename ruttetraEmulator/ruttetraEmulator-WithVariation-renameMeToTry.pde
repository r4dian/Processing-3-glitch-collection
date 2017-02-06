//Christian Attard
//2015 @ introwerks 

PImage img;
String name = "maria"; //file name 
String type = "jpg"; //file type
int count;
color col;
int c;

int frameLimit = 6; // number of images to produce per run
int space =5; // space between lines
float weight = 1; // line weight
float depth = 0.9; // z depth
int zoom = 100; // zoom image

void setup() {
  size(100,100,P3D);
  surface.setResizable(true);
  frameLimit++; // (since the 1st frame is 1 rather than 0, we also offset by one.)
}

void draw() {
  img = loadImage(name + "." + type);
  surface.setSize(img.width,img.height);
  background(0);
  println("christian attard, 2015 @ introwerks");

  /* wait until the next frame so the setSize we just did is applied
   * otherwise you just get the black bg with a 100*100 image stamped on it.
   * Great.
   */
  if (frameCount > 1 && frameCount <= frameLimit ){

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
    
    space += int(random( -3, 3 ));
    weight += int(random( 0, 3 ));
    depth += int(random( -0.3, 0.3 ));
      
    count = int(random(666));
    save(name + "_" + count + "." + type);
  }
  else if(frameCount > frameLimit){
    println("done");
    exit();
  }
}