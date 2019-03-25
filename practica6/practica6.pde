import java.lang.*;
import processing.video.*;
import cvimage.*;
import org.opencv.core.*;
// Detectores
import org.opencv.objdetect.CascadeClassifier;
import org.opencv.objdetect.Objdetect;

Capture cam;
CVImage img;
//Cascadas para de tección
CascadeClassifier face ;
//Nombres de modelos
PImage mascaraActiva;
String faceFile;
String anonymusMask, ironmanMask, spidermanMask, jokerMask, hulkMask;
float alturaMask;
boolean debug = false;
void setup ( ) {
  size (640 , 480) ;
  //Cámara
  cam = new Capture ( this , width , height ) ;
  cam.start();
  //OpenCV
  //Carga biblioteca core de OpenCV
  System.loadLibrary(Core.NATIVE_LIBRARY_NAME) ;
  println(Core.VERSION) ;
  img = new CVImage(cam.width , cam.height) ;
  // Detectores
  faceFile = "haarcascade_frontalface_default.xml" ;
  anonymusMask = "masks/mask.png";
  ironmanMask = "masks/ironman2.png";
  spidermanMask = "masks/spiderman.png";
  jokerMask = "masks/joker.png";
  hulkMask = "masks/hulk.png";
  face = new CascadeClassifier( dataPath (faceFile) ) ;
  mascaraActiva = loadImage(anonymusMask);
  alturaMask = 4;
}

void draw() {
  if(cam.available()) {
    background(0) ;
    cam.read() ;
    
    //Obtiene l a imagen de l a cámara
    img.copy(cam, 0 , 0 , cam.width , cam.height , 0 , 0 , img.width , img.height ) ;
    img.copyTo() ;
    //Imagen de g ri s e s
    Mat gris = img.getGrey();
    //Imagen de entrada
    image (img, 0 , 0 ) ;
    // Detección y pintado de contenedores
    FaceDetect(gris);
    gris.release();
    instrucciones();
  }
}

void instrucciones(){
  textSize(15);
  text("Mascaras",15,15);
  text("1) Anonymous",10,35);
  text("2) Iroman",10,50);
  text("3) Spiderman",10,65);
  text("4) Joker",10,80);
  text("5) Hulk",10,95);
  text("9) Activa/Desactiva debug",10,110);
}
public void keyPressed()
{
   // 49 numero 1 --- 57 numero 9 -- 48 numero 0
    if (keyCode == 49){ alturaMask = 4; mascaraActiva = loadImage(anonymusMask);}
    if (keyCode == 50){ alturaMask = 2; mascaraActiva = loadImage(ironmanMask);}
    if (keyCode == 51){ alturaMask = 2.3; mascaraActiva = loadImage(spidermanMask);}
    if (keyCode == 52){ alturaMask = 2.3; mascaraActiva = loadImage(jokerMask);}
    if (keyCode == 53){ alturaMask = 2.3; mascaraActiva = loadImage(hulkMask);}
    if (keyCode == 57){ if(!debug) debug = true; else debug = false;} 
}

void FaceDetect (Mat grey ){
  
  // Detección de rostros
  MatOfRect faces = new MatOfRect();
  face.detectMultiScale( grey , faces , 1.15 , 3 , Objdetect.CASCADE_SCALE_IMAGE, new Size (60 , 60) , new Size(200 , 200));
  Rect [ ] facesArr = faces.toArray() ;
  
  //Dibuja contenedores
  noFill() ;
  stroke ( 255 , 0 , 0 ) ;
  strokeWeight( 4 ) ;
  for ( Rect r : facesArr ) {
    if(debug) rect( r.x , r.y , r.width , r.height ) ;
    else image(mascaraActiva, r.x-r.width/4, r.y-r.height/alturaMask, r.width+r.width/2, r.height+r.height/2);   
  }
  faces.release ( ) ;
}
