#include <stdio.h>
#include <stdlib.h>
#include <string.h>

#define ROW 1000
#define COL 1000

int main(int argc, char const *argv[])
{

    int SIZE = (ROW * COL) * sizeof(int) ;
    int* tab1 = calloc(ROW*COL, SIZE);
    int* tab2 = malloc(SIZE) ;

    memcpy(tab2, tab1, sizeof(SIZE)) ;

    free(tab1);
    free(tab2);

    return 0;
}

    /*

==9324== I   refs:      2,789,857
==9324== I1  misses:        3,981
==9324== LLi misses:        3,078
==9324== I1  miss rate:      0.14%
==9324== LLi miss rate:      0.11%
==9324== 
==9324== D   refs:      1,047,755  (745,505 rd   + 302,250 wr)
==9324== D1  misses:       13,886  ( 12,375 rd   +   1,511 wr)
==9324== LLd misses:        4,444  (  3,471 rd   +     973 wr)
==9324== D1  miss rate:       1.3% (    1.7%     +     0.5%  )
==9324== LLd miss rate:       0.4% (    0.5%     +     0.3%  )
==9324== 
==9324== LL refs:          17,867  ( 16,356 rd   +   1,511 wr)
==9324== LL misses:         7,522  (  6,549 rd   +     973 wr)
==9324== LL miss rate:        0.2% (    0.2%     +     0.3%  )

------------------------------

desc: I1 cache:         32768 B, 64 B, 8-way associative
desc: D1 cache:         32768 B, 64 B, 8-way associative
desc: LL cache:         4194304 B, 64 B, 16-way associative

    */
