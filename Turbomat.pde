import P5ireBase.library.*;
import processing.video.*;

PFont Display;
PFont DegularLight;
PFont DegularRegular;
PFont DegularBold;

boolean addedValue = false;
int totalBeerCount = 0;
int totalUserCount = 0;
int totalQNaturCount = 0;

int scannedUser = 1;

String beerType = "Q-Natur";
String newUserName = "Fabi";
String newUserCode = "123456789";

P5ireBase fire;
Movie beerVideo;

void setup() {
  frameRate(30);
  size(1920, 1080);
  pixelDensity(displayDensity());
  
  //fullScreen();
  fire = new P5ireBase(this, "https://turbomat-6f94f.firebaseio.com/");//put here ur DB link created in firebase console
  
  Display = createFont("Degular_Display-Black.ttf", 1000);
  DegularLight = createFont("Degular_Text-Light.ttf", 500);
  DegularRegular = createFont("Degular_Text-Regular.ttf", 500);
  DegularBold = createFont("Degular_Text-Bold.ttf", 500);
  textFont(DegularRegular);
  
  beerVideo = new Movie(this, "beerbrown.mp4");
  beerVideo.loop();
  
  thread("requestData");
  
  background(255,255,255);
}

void draw() {
  //scale(0.67);
  image(beerVideo, 0, 0);
  menu();
  
  /*
  if(frameCount == 200){
    thread("newBeer");
  }
  */
}

void Button(String name, String goal, String state){
  if(state == "active"){
    pushStyle();
      fill(255,255,255,128);
      noStroke();
      rect(64,128,50,50,64);
    popStyle();
    pushStyle();
      fill(22,29,71);
      textFont(DegularBold);
      textSize(36);
      text(name,50,50);
    popStyle();
  }
}

void movieEvent(Movie m) {
  m.read();
}

void menu(){
  Button("DRINKS", "x", "active");
}

void newBeer(){
  fire.setValue( "beers/" + beerType + "/" + year() + month() + day() + hour() + minute() + second(), str(scannedUser));
  totalBeerCount++;
  totalQNaturCount++;
  fire.setValue( "totalBeerCount", str(totalBeerCount));
  fire.setValue( "beers/Q-Natur/totalQNaturCount", str(totalQNaturCount));
  delay(1000);
  thread("requestData");
}

void newUser(){
  totalUserCount++;
  fire.setValue( "users/" + totalUserCount + "/name", newUserName);
  fire.setValue( "users/" + totalUserCount + "/code", newUserCode);
  fire.setValue( "users/" + totalUserCount + "/beerCount", "0");
  fire.setValue( "totalUserCount", str(totalUserCount));
  delay(1000);
  thread("requestData");
}

void requestData(){
  fire.getValue("totalUserCount");
  delay(1000);
  totalUserCount = Integer.valueOf(fire.getValue("totalUserCount"));
  println("Users: " + totalUserCount);
  fire.getValue("totalBeerCount");
  delay(1000);
  totalBeerCount = Integer.valueOf(fire.getValue("totalBeerCount"));
  println("Beers: " + totalBeerCount);
  fire.getValue("beers/Q-Natur/totalQNaturCount");
  delay(1000);
  totalQNaturCount = Integer.valueOf(fire.getValue("beers/Q-Natur/totalQNaturCount"));
  println("Q-Natur: " + totalQNaturCount);
}
