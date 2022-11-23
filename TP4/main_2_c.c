#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define ROW 1000
#define COL 1000
int SIZE = (ROW * COL) * sizeof(int) ;


void printTab(int* tab){
    for(int i=0 ; i<COL ; i++){
        for(int j=0 ; j<ROW ; j++) 
            printf("%d ", tab[i*COL+j]) ;
        printf("\n") ;
    }
}

int moyenne(int* tab2, int x, int y){

    int moy = tab2[x*COL+y] ;

    moy += tab2[(x-1)*COL+ (y-1)] ;
    moy += tab2[(x-1)*COL+ (y+0)] ;
    moy += tab2[(x-1)*COL+ (y+1)] ;

    moy += tab2[(x)*COL+ (y-1)] ;
    //moy += tab2[(x)*COL+ (y+0)] ;
    moy += tab2[(x)*COL+ (y+1)] ;
    
    moy += tab2[(x+1)*COL+ (y-1)] ;
    moy += tab2[(x+1)*COL+ (y+0)] ;
    moy += tab2[(x+1)*COL+ (y+1)] ;

    moy /= 9 ;

    
    return moy ;
}


int main(int argc, char const *argv[]) {

    int* tab1 = calloc(ROW*COL, SIZE);
    int* tab2 = malloc(SIZE) ;

    for (int i = 0; i < ROW*COL; i++)
        tab2[i] = rand();

    memcpy(tab1, tab2, SIZE) ;

    for(int i = 1 ; i<ROW-1 ; i++){
        for(int k=1 ; k<COL-1 ; k++) {
            tab1[i*COL+k] = moyenne(tab2, i, k) ;
        }
    }

    free(tab1);
    free(tab2);

    return 0;
}

    /*

==55643== Command: ./main
==55643== 
--55643-- warning: L3 cache found, using its data for the LL simulation.
==55643== 
==55643== I   refs:      136,321,582
==55643== I1  misses:          3,970
==55643== LLi misses:          3,138
==55643== I1  miss rate:        0.00%
==55643== LLi miss rate:        0.00%
==55643== 
==55643== D   refs:       90,753,321  (66,520,973 rd   + 24,232,348 wr)
==55643== D1  misses:        326,663  (   200,099 rd   +    126,564 wr)
==55643== LLd misses:        310,433  (   184,425 rd   +    126,008 wr)
==55643== D1  miss rate:         0.4% (       0.3%     +        0.5%  )
==55643== LLd miss rate:         0.3% (       0.3%     +        0.5%  )
==55643== 
==55643== LL refs:           330,633  (   204,069 rd   +    126,564 wr)
==55643== LL misses:         313,571  (   187,563 rd   +    126,008 wr)
==55643== LL miss rate:          0.1% (       0.1%     +        0.5%  )

    */
