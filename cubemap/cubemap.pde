/* cubemap.pde by Teisu */

String mapname = "cubemapped.jpg";
String baseString = "garden.png";
Boolean createMap = true;

PImage cubetex, equitex;
void setup() { 
  if ( createMap ) { 
    cubetex = loadCube(baseString);
    cubetex.save(mapname);
  } else { 
    cubetex = loadImage(mapname);
  }
  int baseh = (int)(cubetex.height/3);
  //size(cubetex.width,cubetex.height,P2D);
  size(baseh*2, baseh, P2D); 
  noLoop();
}
void draw() { 
  int baseh = (int)(cubetex.height/3);
  equitex = cubemapped(cubetex, baseh*2, baseh);
  equitex.save("result.png");
  println("Saved result.png");
  image(equitex, 0, 0);
  
}
PImage loadCube(String basename) { 
  PImage ptop, pleft, pright, pbottom, pfront, pbehind; 
  ptop = loadImage("top_"+basename);
  pleft = loadImage("left_"+basename);
  pright = loadImage("right_"+basename);
  pbottom = loadImage("bottom_"+basename);
  pfront = loadImage("front_"+basename);
  pbehind = loadImage("behind_"+basename);
  PImage result = createImage(ptop.width*4, ptop.height*3, RGB);
  result.copy(ptop, 0, 0, ptop.width, ptop.height, ptop.width, 0, ptop.width, ptop.height);
  result.copy(pleft, 0, 0, pleft.width, pleft.height, 0, pleft.height, pleft.width, pleft.height);
  result.copy(pfront, 0, 0, pfront.width, pfront.height, pfront.width, pfront.height, pfront.width, pfront.height);
  result.copy(pright, 0, 0, pright.width, pright.height, pright.width*2, pright.height, pright.width, pright.height);
  result.copy(pbehind, 0, 0, pbehind.width, pbehind.height, pbehind.width*3, pbehind.height, pbehind.width, pbehind.height);
  result.copy(pbottom, 0, 0, pbottom.width, pbottom.height, pbottom.width, pbottom.height*2, pbottom.width, pbottom.height);


  return result;
}


PImage cubemapped(PImage cubemap, int outputWidth, int outputHeight) { 
// from Bartosz answer on http://stackoverflow.com/questions/34250742/converting-a-cubemap-into-equirectangular-panorama 
  PImage result = createImage(outputWidth, outputHeight, RGB); 
  float u, v; //normalized texture coordinates from 0 to 1
  float phi, theta; //polar coords
  int cW, cH;

  cW = cubemap.width / 4;
  cH = cubemap.height/3;
  int cutoff = 0;
  for ( int y = 0, h = result.height; y<h; y++ ) { 
    v = 1 - ((float)y / h);
    theta = v * PI;
    for ( int x = 0, w = result.width; x<w; x++ ) {
      // cols start from left
      u = ((float) x / w );
      phi = u * 2 * PI;
      float tx, ty, tz; //unit vector
      tx = sin(phi) * sin(theta) * -1;
      ty = cos(theta);
      tz = cos(phi) * sin(theta) * -1;

      float xa, ya, za, a;
      //println("tx: "+tx+", ty: "+ty+", tz: "+tz);

      a = getmax(tx, ty, tz);
      //println(a);
      xa = tx / a;
      ya = ty / a;
      za = tz / a;

      int c = 0, xp = 0, yp = 0, xoffset = 0, yoffset = 0;

      //println("xa: "+xa+", za: "+za+", ya: "+ya);   
      //if ( cutoff++ > 10 ) return cubemap; 
      if ( xa == 1 ) {
        //right
        xp = (int)(((( za + 1f ) / 2f ) - 1f ) * cW);
        xoffset = 2 * cW;
        yp = (int)(((( ya + 1f ) / 2f )) * cH);
        yoffset = cH;
      } else if (xa == -1)
      {
        //Left
        xp = (int)((((za + 1f) / 2f)) * cW);
        xoffset = 0;
        yp = (int)((((ya + 1f) / 2f)) * cH);
        yoffset = cH;
      } else if (ya == 1)
      {
        //Up
        xp = (int)((((xa + 1f) / 2f)) * cW);
        xoffset = cW;
        yp = (int)((((za + 1f) / 2f) - 1f) * cH);
        yoffset = 2 * cH;
      } else if (ya == -1)
      {
        //Down
        xp = (int)((((xa + 1f) / 2f)) * cW);
        xoffset = cW;
        yp = (int)((((za + 1f) / 2f)) * cH);
        yoffset = 0;
      } else if (za == 1)
      {
        //Front
        xp = (int)((((xa + 1f) / 2f)) * cW);
        xoffset = cW;
        yp = (int)((((ya + 1f) / 2f)) * cH);
        yoffset = cH;
      } else if (za == -1)
      {
        //Back
        xp = (int)((((xa + 1f) / 2f) - 1f) * cW);
        xoffset = 3 * cW;
        yp = (int)((((ya + 1f) / 2f)) * cH);
        yoffset = cH;
      } else
      {
        println("Unknown face, something went wrong");
        xp = 0;
        yp = 0;
        xoffset = 0;
        yoffset = 0;
      }

      xp = abs(xp);
      yp = abs(yp);
      xp += xoffset;
      yp += yoffset;

      int sp = xp + yp * cubemap.width;
      int tp = x + y * result.width;
      if ( sp > -1 && sp < cubemap.pixels.length -1 && tp > -1 && tp < result.pixels.length - 1) { 
        result.pixels[tp] = cubemap.pixels[sp];
      } else { 
        println("wtf");
      }
    }
  }
  result.updatePixels();
  return result;
}

float getmax(float f1, float f2, float f3 ) { 
  f1 = abs(f1);
  f2 = abs(f2);
  f3 = abs(f3);
  if ( f1 >= f2 && f1 >= f3 ) { 
    return f1;
  } else if ( f2 >= f1 && f2 >= f3 ) { 
    return f2;
  } else if ( f3 >= f1 && f3 >= f2 ) { 
    return f3;
  } 
  return f1;
}

