#include <stdio.h>
#include <stdlib.h>

#define ROW 1000
#define COL 1000

int main(int argc, char const *argv[])
{
 
    int tab1[ROW][COL];
    int tab2[ROW][COL];

    for (int i = 0; i < COL; i++)
        for(int j=0 ; j < ROW ; j++)
            tab1[j][i] = 0;
 
    for (int i = 0; i < COL; i++)
        for(int j=0 ; j < ROW ; j++)
            tab2[j][i] = tab1[j][i];
 
    return 0;
}


    /*

==8536== I   refs:      32,757,317
==8536== I1  misses:         3,885
==8536== LLi misses:         3,045
==8536== I1  miss rate:       0.01%
==8536== LLi miss rate:       0.01%
==8536== 
==8536== D   refs:      16,040,233  (11,739,769 rd   + 4,300,464 wr)
==8536== D1  misses:     3,013,824  ( 1,012,318 rd   + 2,001,506 wr)
==8536== LLd misses:       187,854  (    61,634 rd   +   126,220 wr)
==8536== D1  miss rate:       18.8% (       8.6%     +      46.5%  )
==8536== LLd miss rate:        1.2% (       0.5%     +       2.9%  )
==8536== 
==8536== LL refs:        3,017,709  ( 1,016,203 rd   + 2,001,506 wr)
==8536== LL misses:        190,899  (    64,679 rd   +   126,220 wr)
==8536== LL miss rate:         0.4% (       0.1%     +       2.9%  )

------------------------------

desc: I1 cache:         32768 B, 64 B, 8-way associative
desc: D1 cache:         32768 B, 64 B, 8-way associative
desc: LL cache:         4194304 B, 64 B, 16-way associative

    */
