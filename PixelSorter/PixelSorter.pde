PImage img;
int i;

//choose how many pixels are sorted at once
int step = 100;

//fast / sliced mode
boolean sliced = true;

// 0 = idk (very fast)
// 1 = fast hue
// 2 = slow hue
// 3 = fast luminance
// 4 = slow luminance
int sort = 0;

void setup() {
  i=0;
  //iceland.jpg from tpsdave
  //smarties.jpg from eismannhans
  //flower.jpg from Bessi
  img = loadImage("iceland.jpg");
  size(500, 500);
  frameRate(120);
}

void draw() {
  for (int n = 0; n < step; n++) {
    if (i < img.pixels.length -1) {
      for (int j = i; j < img.pixels.length && !sliced || j < i+(img.width-i%img.width); j ++) {
        if (eval(img.pixels[i]) < eval(img.pixels[j])) {
          swap(i, j);
        }
      }
      i++;
    }
  }
  background(img.pixels[i]);
  img.updatePixels();
  image(img, (width-img.width)/2, (height-img.height)/2);
  text(frameRate, 0, 16);
}

void swap(int x, int y) {
  color tmp = img.pixels[x];
  img.pixels[x] = img.pixels[y];
  img.pixels[y] = tmp;
}

float eval(color c) {
  if (sort == 1) {
    float min = min(min(red(c), green(c)), blue(c));
    float max = max(max(red(c), green(c)), blue(c));
    if (min == max) return 0;
    float hue = 0f;
    if (max == red(c)) {
      hue = (green(c)-blue(c))/(max-min);
    } else if (max == green(c)) {
      hue = 2f+(blue(c)-red(c))/(max-min);
    } else {
      hue = 4f+(red(c)-green(c))/(max-min);
    }
    hue = hue * 60;
    if (hue < 0) hue = hue + 360;
    return(hue);
  }
  if (sort == 2) {
    return(hue(c));
  }
  if (sort == 3) {
    return(0.2126*red(c)+0.7152*green(c)+0.0722*blue(c));
  }
  if (sort == 4) {
    return(sqrt(0.299*pow(red(c), 2)+0.587*pow(green(c), 2)+0.114*pow(blue(c), 2)));
  }
  return(c);
}
