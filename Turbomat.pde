import P5ireBase.library.*;
import processing.video.*;

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
  size(1920, 1080);
  //fullScreen();
  fire = new P5ireBase(this, "https://turbomat-6f94f.firebaseio.com/");//put here ur DB link created in firebase console
  
  beerVideo = new Movie(this, "beerlarge.mp4");
  beerVideo.loop();
  
  thread("requestData");
}

void draw() {
  image(beerVideo, 0, 0);
  
  if(frameCount == 200){
    thread("newBeer");
  }
  
  if(frameCount == 800){
    thread("newUser");
  }
  
  if(frameCount == 1000){
    thread("newBeer");
  }
}
void movieEvent(Movie m) {
  m.read();
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

/*
void newBeer(){
    int beersCount = int(fire.getValue( "users/" + randomID +"/beersCount"));
    beersCount++;
    fire.setValue( "users/" + randomID +"/beersCount", str(beersCount));
    println(randomID + "drunk" + beersCount);
}
*/
