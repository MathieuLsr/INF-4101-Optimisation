/*
 * Fichier source pour le projet d'unité
 *  INF-4101C
 *---------------------------------------------------------------------------------------------------
 * Pour compiler : g++ `pkg-config --cflags opencv` projet_base.cpp `pkg-config --libs opencv` -o projet
 *---------------------------------------------------------------------------------------------------
 * auteur : Eva Dokladalova 09/2015
 * modification : Eva Dokladalova 10/2021
 */

/*

Sans créer de variables intermédiaires : 
Sobel : 86196.000000

Avec var inter : 
Sobel : 46117.000000

Le fait d'essayer de changer de places les var intermédiaires ne font pas grand chose 

abs(sumX)+abs(sumY) / 8 fait gagner 5% de perf mais nous n'avons pas un résultat convaincant 
Le filtre est trop noir et ne délimite pas bien les contours 
Nous faisons le choix d eperdre en performances mais de gagner en précision sur le filtre

En supprimant les calculs inutils (les *0)
Sobel : 45341.000000

en suppr les *1 : 
Sobel : 44629.000000


------------------

Mediane par défaiut : 
Mediane : 18550.000000


Premier jet pour median : 
Mediane : 770169.000000

En améliorant le sort : 
New Mediane : 758912.000000

Avec le déroulage de boucle : 
New Mediane : 754565.000000

En utilisant des Points au lieu de x,y : Point p(j , i) ;
New Mediane : 764875.000000
 
Résultat final : 
New Mediane : 745102.000000




*/


/*
 * Libraries stantards
 *
 */
#include <stdio.h>
#include <stdlib.h>
#include <math.h>
#include <algorithm>    // std::sort
#include <vector>       // std::vector

#include <unistd.h>
#include <sys/types.h>
#include <sys/wait.h>

/*
 * Libraries OpenCV "obligatoires"
 *
 */
#include "highgui.h"
#include "cv.h"
#include "opencv2/opencv.hpp"
#include "opencv2/imgproc/imgproc.hpp"
#include "opencv2/highgui/highgui.hpp"

/*
 * Définition des "namespace" pour évite cv::, std::, ou autre
 *
 */
using namespace std;
using namespace cv;
using std::cout;

/*
 * Some usefull defines
 * (comment if not used)
 */
#define PROFILE
#define VAR_KERNEL
#define N_ITER 100

#ifdef PROFILE
#include <time.h>
#include <sys/time.h>
#endif

int sort_array(int tab[9]){
	std::vector<int> myvector (tab, tab+9);               // 32 71 12 45 26 80 53 33 45
                                                          // 12 26 32 33 45 71 80 53 45 

	// using default comparison (operator <):
  	std::partial_sort (myvector.begin(), myvector.begin()+5, myvector.end());

	//std::cout << "myvector contains:";
	//for (std::vector<int>::iterator it=myvector.begin(); it!=myvector.end(); ++it)
	//	std::cout << ' ' << *it;
	//std::cout << '\n';
	return myvector[4] ; 
}

void newMedian(Mat in, Mat out, int rows, int cols, int n)
{
	int sumX, sumY;
	for(int j = 1; j < cols - 1; j++)
		for(int i = 1; i < rows - 1; i++)
		{
	
			int c1 = (int)in.at<unsigned char>(i - 1, j - 1) ;
			int c4 = (int)in.at<unsigned char>(i-1, j) ;
			int c7 = (int)in.at<unsigned char>(i - 1, j + 1);

			int c2 = (int)in.at<unsigned char>(i, j - 1 ) ;
			int c5 = (int)in.at<unsigned char>(i, j) ;
			int c8 = (int)in.at<unsigned char>( i, j + 1);

			int c3 = (int)in.at<unsigned char>(i + 1, j - 1) ;
			int c6 = (int)in.at<unsigned char>(i + 1, j) ;
			int c9 = (int)in.at<unsigned char>(i + 1, j + 1) ;

			int array[9] = {c1, c2, c3, c4, c5, c6, c7, c8, c9} ;

			int medianint = sort_array(array) ;
			out.at<unsigned char>(i, j) = (unsigned char) medianint ;
			
		}
}

void newSobel(Mat in, Mat out, int rows, int cols)
{
	int Hx[9] = {-1,0,1,-2,0,2,-1,0,1};
	int Hy[9] = {1,2,1,0,0,0,-1,-2,-1};
	int sumX, sumY;
	for(int j = 1; j < cols - 1; j++)
		for(int i = 1; i < rows - 1; i++)
		{
			sumX = 0; sumY = 0;// count = 0;
		
			unsigned char c1 = in.at<unsigned char>(i - 1, j - 1) ;
			unsigned char c4 = in.at<unsigned char>(i - 1, j) ;
			unsigned char c7 = in.at<unsigned char>(i - 1, j + 1);

			unsigned char c2 = in.at<unsigned char>(i, j - 1) ;
			unsigned char c5 = in.at<unsigned char>(i, j) ;
			unsigned char c8 = in.at<unsigned char>(i, j + 1);

			unsigned char c3 = in.at<unsigned char>(i + 1, j - 1) ;
			unsigned char c6 = in.at<unsigned char>(i + 1, j) ;
			unsigned char c9 = in.at<unsigned char>(i + 1, j + 1) ;

			sumX += c1 * Hx[0];
			sumY += c1 ; //* Hy[0];

			//sumX += c2 * Hx[1];
			sumY += c2 * Hy[1];

			sumX += c3 ; // * Hx[2];
			sumY += c3 ; // * Hy[2];

			sumX += c4 * Hx[3];
			//sumY += c4 * Hy[3];

			//sumX += c5 * Hx[4];
			//sumY += c5 * Hy[4];

			sumX += c6 * Hx[5];
			//sumY += c6 * Hy[5];

			sumX += c7 * Hx[6];
			sumY += c7 * Hy[6];

			//sumX += c8 * Hx[7];
			sumY += c8 * Hy[7];

			sumX += c9 ; // * Hx[8];
			sumY += c9 * Hy[8];

			out.at<unsigned char>(i, j) = (unsigned char)(sqrt(sumX*sumX + sumY*sumY));
			//out.at<unsigned char>(i, j) = (unsigned char) (( abs(sumX)+abs(sumY) )/8) ;
		}
}

/*
 *
 *--------------- MAIN FUNCTION ---------------
 *
 */
int main () {
//----------------------------------------------
// Video acquisition - opening
//----------------------------------------------

int port = 0 ;
for(int i=0 ; i<5 ; i++) { // Code pour débug le port des vidéos 
    VideoCapture cap(i) ;
    if(cap.isOpened()) {
        cout << "Port à utiliser : " << i << endl ;
        port = i ; 
        break ;
    }
}

  VideoCapture cap(port); // le numéro 0 indique le point d'accès à la caméra 0 => /dev/video0
  if(!cap.isOpened()){
    cout << "Errore"; // 
    return -1;
  }
// HD resolution  1 920 × 1 080,
  int rows = 240; // 480, 1080
  int cols = 320; // 640, 1920
  cap.set(CAP_PROP_FRAME_WIDTH, cols);
  cap.set(CAP_PROP_FRAME_HEIGHT, rows);

//----------------------------------------------
// Déclaration des variables - imagesize
// Mat - structure contenant l'image 2D niveau de gris
// Mat3b - structure contenant l'image 2D en couleur (trois cannaux)
//
  Mat3b frame; // couleur
  Mat frame1; // niveau de gris
  Mat frame_gray; // niveau de gris
  Mat grad_x;
  Mat grad_y;
  Mat abs_grad_y;
  Mat abs_grad_x;
  Mat grad;

// variable contenant les paramètres des images ou d'éxécution
  int ddepth = CV_16S;
  int scale = 1;
  int delta = 0;
  unsigned char key = '0';

 #define PROFILE

#ifdef PROFILE
// profiling / instrumentation libraries
#include <time.h>
#include <sys/time.h>
#endif

//----------------------------------------------------
// Création des fenêtres pour affichage des résultats
// vous pouvez ne pas les utiliser ou ajouter selon ces exemple
//
  cvNamedWindow("Video input", WINDOW_AUTOSIZE);
  cvNamedWindow("Video gray levels", WINDOW_AUTOSIZE);
  cvNamedWindow("Video Mediane", WINDOW_AUTOSIZE);
  cvNamedWindow("Video Edge detection", WINDOW_AUTOSIZE);
// placement arbitraire des  fenêtre sur écran
// sinon les fenêtres sont superposée l'une sur l'autre
  cvMoveWindow("Video input", 10, 30);
  cvMoveWindow("Video gray levels", 800, 30);
  cvMoveWindow("Video Mediane", 10, 500);
  cvMoveWindow("Video Edge detection", 800, 500);


// --------------------------------------------------
// boucle infinie pour traiter la séquence vidéo
//

  while(key!='q'){
  //
  // acquisition d'une trame video - librairie OpenCV
    cap.read(frame);
  //conversion en niveau de gris - librairie OpenCV
    cvtColor(frame, frame_gray, CV_BGR2GRAY);


   // image smoothing by median blur
   //
    int n = 5;

    #ifdef PROFILE
        struct timeval start, end;
        gettimeofday(&start, NULL);
    #endif

        // ------------------------------------------------
        // calcul de la mediane - librairie OpenCV
        frame1 = frame_gray.clone();
        newMedian(frame_gray, frame1, rows, cols, n);
        //medianBlur(frame_gray, frame1, n);
    #ifdef PROFILE
    gettimeofday(&end, NULL);
    double e = ((double) end.tv_sec * 1000000.0 + (double) end.tv_usec);
    double s = ((double) start.tv_sec * 1000000.0 + (double) start.tv_usec);
    printf("New Mediane : %lf\n", n, (e - s));

    #endif

    #ifdef PROFILE
        gettimeofday(&start, NULL);
    #endif


    // ------------------------------------------------
    // calcul du gradient- librairie OpenCV
    grad = frame1.clone();
    /// Gradient Y
    /*Sobel( frame1, grad_x, ddepth, 1, 0, 3, scale, delta, BORDER_DEFAULT );
/// absolute value
    convertScaleAbs( grad_x, abs_grad_x );
    /// Gradient Y
    Sobel( frame1, grad_y, ddepth, 0, 1, 3, scale, delta, BORDER_DEFAULT );
/// absolute value
    convertScaleAbs( grad_y, abs_grad_y );
    /// Total Gradient (approximate)
    addWeighted( abs_grad_x, 0.5, abs_grad_y, 0.5, 0, grad );*/
    newSobel(frame1, grad, rows, cols);

    #ifdef PROFILE
    gettimeofday(&end, NULL);
    e = ((double) end.tv_sec * 1000000.0 + (double) end.tv_usec);
    s = ((double) start.tv_sec * 1000000.0 + (double) start.tv_usec);
    printf("Sobel : %lf\n", (e - s));

    #endif



    // -------------------------------------------------
    // visualisation
    // taille d'image réduite pour meuilleure disposition sur écran
    //    resize(frame, frame, Size(), 0.5, 0.5);
    //    resize(frame_gray, frame_gray, Size(), 0.5, 0.5);
    //    resize(grad, grad, Size(), 0.5, 0.5);
    imshow("Video input",frame);
    imshow("Video gray levels",frame_gray);
    imshow("Video Mediane",frame1);
    imshow("Video Edge detection",grad);


    key=waitKey(5);
  }
}
