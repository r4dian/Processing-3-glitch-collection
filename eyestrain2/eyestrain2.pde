PImage img, simg;
int w = 1024, h = 768;
int cubesize = 40;
float squareToLineRatio = 0.2;
color basecolor = color(0, 0, 0);
Boolean useImage = true;
String imgpath = "source.jpg";
String resultpath = "result.png";
int brthres = 160; //(0-255)
Boolean glitch = true;
color circc, linec;
int lineopacity = 178; //(0-255)
Boolean done = false;
void settings() { 
  if ( useImage ) { 
    img = loadImage(imgpath);
    size(w, h, P2D);//img.width, img.height, P2D);
    simg = createImage(w, h, RGB);
    simg.copy(img, 0, 0, img.width, img.height, 0, 0, simg.width, simg.height);
  } else { 
    size(w, h, P2D);//img.width, img.height, P2D);
  }
}

void setup() {
  noStroke();
}
void draw() { 
  if ( done) { 
    save(resultpath);
    println("Saved "+resultpath);
    done = false;
    noLoop();
  }
  int sq2linrat = (int)(1.0/squareToLineRatio);
  int sqw = cubesize, linw = sqw/sq2linrat, cirw = (int)(linw*1.5);
  int sqh = cubesize, linh = sqh/sq2linrat, cirh = (int)(linh*1.5);
  color c = basecolor;
  circc = useImage ? color(255) : revcolor(c);//
  linec = color( abs(red(circc)-124), abs(green(circc)-124), abs(blue(circc)-124));
  int cx = 0, cy = 0;
  if ( useImage ) { 
    copy(img, 0, 0, img.width, img.height, 0, 0, width, height);
    filter(INVERT);
    fill(color(red(linec), green(linec), blue(linec), lineopacity));
    rect(0, 0, width, height);
  } else { 
    background(linec);
  }
  int iter = 1;
  // paint the squares
  fill(c);
  while ( ! (cy + sqh +linh > h && cx + sqw +linw > w ) ) { 
    if ( useImage ) {
      PImage sqim = createImage(sqw, sqh, RGB);
      sqim.copy(simg, cx, cy, sqw, sqh, 0, 0, sqim.width, sqim.height);
      image(darker(sqim), cx, cy);
    } else { 
      rect(cx, cy, sqw, sqh);
    }
    cx += sqw + linw;
    if ( cx > w && cy < h ) { 
      cx = 0;
      cy += sqh + linh;
    }
  }
  cx = cy = 0;
  // now paint the circles
  fill(circc);
  ellipseMode(CORNER);
  while ( ! (cy + sqh > h && cx + sqw > w ) ) { 
    ellipse(cx + sqw - (linw/4), cy + sqh - (linh/4), cirw, cirh);
    cx += sqw + linw;
    if ( cx > w && cy < h ) { 
      cx = 0;
      cy += sqh + linh;
    }
  }
  updatePixels();
  done = true;
}
PImage darker(PImage im) { 
  if ( !glitch) return im;
  im.loadPixels();
  for ( int i = im.pixels.length -1; i>-1; i--) { 
    if ( brightness(im.pixels[i]) > brthres )  im.pixels[i] = basecolor;
  } 
  im.updatePixels();
  return im;
}

PImage lighter(PImage im) { 
  if ( !glitch) return im;
  im.loadPixels();
  for ( int i = im.pixels.length -1; i>-1; i--) { 
    if ( brightness(im.pixels[i]) <= brthres )  im.pixels[i] = linec;
  } 
  im.updatePixels();
  return im;
}

color revcolor(color c) { 
  return  color( abs(255-red(c)), abs(255-green(c)), abs(255-blue(c)));
}