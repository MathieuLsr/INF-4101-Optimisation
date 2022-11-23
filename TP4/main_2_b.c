#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#define ROW 1000
#define COL 1000

void printTab(int tab[ROW][COL]){

    for(int i=0 ; i<ROW ; i++){
        for(int j=0 ; j<COL ; j++) printf("%d ", tab[i][j]) ;
        printf("\n") ;
    }

}

int moyenne(int tab[ROW][COL], int x, int y){

    int moy = 0 ;

    moy += tab[x][y] ;
    moy += tab[x+1][y] ;
    moy += tab[x-1][y] ;
    
    moy += tab[x-1][y+1] ;
    moy += tab[x][y+1] ;
    moy += tab[x+1][y+1] ;

    moy += tab[x-1][y-1] ;
    moy += tab[x][y-1] ;
    moy += tab[x+1][y-1] ;

    return moy/9 ;

}

int main(int argc, char const *argv[])
{
 
    srand(time(NULL));   // Initialization, should only be called once.
  
    int tab1[ROW][COL];
    int tab2[ROW][COL];

    for (int i = 0; i < COL; i++)
        for(int j=0 ; j < ROW ; j++){
            //tab1[j][i] = rand();
            //tab1[j][i] = i+j;
            tab2[j][i] = rand();
        }
            

    for(int i = 1 ; i<ROW-1 ; i++)
        for(int k=1 ; k<COL-1 ; k++){
            tab1[i][k] = moyenne(tab2, i, k) ;
        }
 

    /*

==10243== I   refs:      166,310,488
==10243== I1  misses:          3,919
==10243== LLi misses:          3,075
==10243== I1  miss rate:        0.00%
==10243== LLi miss rate:        0.00%
==10243== 
==10243== D   refs:       93,773,968  (71,535,149 rd   + 22,238,819 wr)
==10243== D1  misses:      4,138,781  ( 1,074,863 rd   +  3,063,918 wr)
==10243== LLd misses:        340,081  (   108,158 rd   +    231,923 wr)
==10243== D1  miss rate:         4.4% (       1.5%     +       13.8%  )
==10243== LLd miss rate:         0.4% (       0.2%     +        1.0%  )
==10243== 
==10243== LL refs:         4,142,700  ( 1,078,782 rd   +  3,063,918 wr)
==10243== LL misses:         343,156  (   111,233 rd   +    231,923 wr)
==10243== LL miss rate:          0.1% (       0.0%     +        1.0%  )

    ------------------------------

desc: I1 cache:         32768 B, 64 B, 8-way associative
desc: D1 cache:         32768 B, 64 B, 8-way associative
desc: LL cache:         4194304 B, 64 B, 16-way associative

    */

    return 0;
}
