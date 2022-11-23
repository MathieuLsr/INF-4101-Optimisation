#include <stdio.h>
#include <stdlib.h>

#define ROW 1000
#define COL 1000

int main(int argc, char const *argv[])
{

    int tab1[ROW][COL];
    int tab2[ROW][COL];

    for (int i = 0; i < ROW; i++)
        for(int j=0 ; j < COL ; j++)
            tab1[i][j] = 0;
 
    for (int i = 0; i < ROW; i++)
        for(int j=0 ; j < COL ; j++)
            tab2[i][j] = tab1[i][j];
 
    free(tab1);
    free(tab2);

    return 0;
}
    /*

==8029== I   refs:      32,756,683
==8029== I1  misses:         3,840
==8029== LLi misses:         3,045
==8029== I1  miss rate:       0.01%
==8029== LLi miss rate:       0.01%
==8029== 
==8029== D   refs:      16,039,944  (11,739,595 rd   + 4,300,349 wr)
==8029== D1  misses:       201,291  (    74,799 rd   +   126,492 wr)
==8029== LLd misses:       185,799  (    59,980 rd   +   125,819 wr)
==8029== D1  miss rate:        1.3% (       0.6%     +       2.9%  )
==8029== LLd miss rate:        1.2% (       0.5%     +       2.9%  )
==8029== 
==8029== LL refs:          205,131  (    78,639 rd   +   126,492 wr)
==8029== LL misses:        188,844  (    63,025 rd   +   125,819 wr)
==8029== LL miss rate:         0.4% (       0.1%     +       2.9%  )

------------------------------

desc: I1 cache:         32768 B, 64 B, 8-way associative
desc: D1 cache:         32768 B, 64 B, 8-way associative
desc: LL cache:         4194304 B, 64 B, 16-way associative


    */

