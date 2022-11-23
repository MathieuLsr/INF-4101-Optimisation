echo "Cache size :  1024B"
valgrind --tool=cachegrind --D1=1024,1,32 ./$1 &> way_1
valgrind --tool=cachegrind --D1=1024,2,32 ./$1 &> way_2
valgrind --tool=cachegrind --D1=1024,4,32 ./$1 &> way_4
valgrind --tool=cachegrind --D1=1024,8,32 ./$1 &> way_8

grep D1 way_* | grep misses &> "1024.txt"

echo "Cache size :  2048B"
valgrind --tool=cachegrind --D1=2048,1,32 ./$1 &> way_1
valgrind --tool=cachegrind --D1=2048,2,32 ./$1 &> way_2
valgrind --tool=cachegrind --D1=2048,4,32 ./$1 &> way_4
valgrind --tool=cachegrind --D1=2048,8,32 ./$1 &> way_8

grep D1 way_* | grep misses &> "2048.txt"

echo "Cache size :  4096B"
valgrind --tool=cachegrind --D1=4096,1,32 ./$1 &> way_1
valgrind --tool=cachegrind --D1=4096,2,32 ./$1 &> way_2
valgrind --tool=cachegrind --D1=4096,4,32 ./$1 &> way_4
valgrind --tool=cachegrind --D1=4096,8,32 ./$1 &> way_8

grep D1 way_* | grep misses &> "4096.txt"

echo "Cache size :  8192B"
valgrind --tool=cachegrind --D1=8192,1,32 ./$1 &> way_1
valgrind --tool=cachegrind --D1=8192,2,32 ./$1 &> way_2
valgrind --tool=cachegrind --D1=8192,4,32 ./$1 &> way_4
valgrind --tool=cachegrind --D1=8192,8,32 ./$1 &> way_8

grep D1 way_* | grep misses &> "8192.txt"

echo "Cache size :  16384B"
valgrind --tool=cachegrind --D1=16384,1,32 ./$1 &> way_1
valgrind --tool=cachegrind --D1=16384,2,32 ./$1 &> way_2
valgrind --tool=cachegrind --D1=16384,4,32 ./$1 &> way_4
valgrind --tool=cachegrind --D1=16384,8,32 ./$1 &> way_8

grep D1 way_* | grep misses &> "16384.txt"

echo Removing cachegrind files 
rm cachegrind.out*