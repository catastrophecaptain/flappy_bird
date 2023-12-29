#define c3 249
#define d3 222
#define e3 198
#define f3 187
#define g3 166
#define le 157
#define a3 148
#define b3 132
#define c4 124
#define d4 110
#define me 104
#define e4 98
#define f4 93
#define g4 83
#define a4 73
#define b4 65
#define c5 62
#define d5 55
#define e5 49
#define f5 46
#define g5 41
#define a5 36
#define b5 32
#define xz 1
#define pai 0.5/16
const int wholenote[]={c3,d3,e3,f3,g3,a3,b3,c4,d4,e4,f4,g4,a4,b4,c5,d5,e5,f5,g5,a5,b5};

const int songbie[]={g4,e4,g4,c5,a4,c5,g4,xz,g4,c4,d4,e4,d4,c4,d4,xz,
                   g4,e4,g4,c5,b4,a4,c5,g4,xz,g4,d4,e4,f4,b3,c4,xz,
                   a4,c5,xz,c5,b4,a4,b4,c5,a4,b4,c5,a4,xz,a4,g4,e4,c4,d4,xz,
                   g4,e4,g4,c5,b4,a4,c5,g4,xz,g4,d4,e4,f4,b3,c4,xz};
const int songbie_sus[]=  {16, 8, 8,32,16,16,31,xz,16, 8, 8,16, 8, 8,56, 8,
                   16, 8, 8,24, 8,16,16,31,xz,16, 8, 8,24, 8,57, 7,
                   16,16,xz,31,16, 8, 8,32, 8, 8, 8, 8,xz, 8, 8, 8, 8,57, 6,
                   16, 8, 8,24, 8,16,16,31,xz,16, 8, 8,24, 8,56, 24};//送别
const int The_sally_garden[]={c4,d4,e4,d4,c4,d4,e4,g4,a4,g4,c5,g4,a4,g4,e4,d4,c4,d4,e4,xz,
                              c4,d4,e4,d4,c4,d4,e4,g4,a4,g4,c5,g4,a4,g4,e4,d4,c4,xz,c4,xz,
                              g4,xz,g4,c5,b4,g4,a4,c5,a4,b4,g4,e4,g4,a4,g4,e4,g4,a4,c5,d5,e5,xz,
                              g4,xz,g4,c5,b4,g4,a4,c5,a4,b4,g4,e4,g4,a4,g4,e4,g4,a4,c5,d5,c5,xz};
const int The_sally_garden_sus[]={ 8, 8,16, 8, 8,16, 8, 8,32,16, 8, 8,16, 8, 8,16, 8, 8,47,xz,
                               8, 8,16, 8, 8,16, 8, 8,32,16, 8, 8,16, 8, 8,16,15,xz,47,xz,
                               8,xz, 7,16, 8, 8,16, 8, 8,32,16, 8, 8,16, 8, 8, 8, 8, 8, 8,47,xz,
                               8,xz, 7,16, 8, 8,16, 8, 8,32,16, 8, 8,16, 8, 8, 8, 8, 8, 8,47,16,};
const int Sb_fair[]={d4,xz,d4,a4,xz,a4,xz,a4,e4,f4,e4,d4,xz,
                     a4,c5,d5,c5,a4,b4,g4,a4,xz,
                     d5,xz,d5,xz,d5,c5,a4,xz,a4,g4,f4,e4,xz,
                     d4,a4,g4,f4,e4,d4,c4,d4,xz};
const int Sb_fair_sus[]={24,xz,11,12,xz,12,xz,10,18, 6,12,72,12,
                     12,12,24,12,12,12,12,100,26,
                     12,xz,23,xz,11,24,11,xz,12,12,12,66,6,
                     24,12,24,12,12,12,12,100,44};
const int Market_street[]={c4,d4,e4,xz,e4,xz,e4,d4,e4,f4,xz,f4,xz,
                           f4,e4,f4,g4,xz,g4,d4,f4,e4,d4,e4,d4,
                           c4,xz,c4,xz,c4,a3,c4,d4,xz,d4,xz,e4,
                           c4,e4,f4,g4,d4,xz,d4,e4,f4,
                           g4,xz,g4,xz,g4,a4,b4,g4,xz,g4,a4,b4,
                           c5,g4,xz,g4,f4,e4,g4,d5,g4,c5,b4,c5,a4,d5,
                           c5,b4,a4,b4,xz,c5,xz};
const int Market_street_sus[]={8,4,8,4,12,7,4,8,4,12,8,4,8,
                           4,8,4,12,xz,11,12,12,24,12,8,4,
                           11,xz,12,8,4,8,4,12,8,4,12,12,
                           12,12,12,12,12,20,4,8,4,
                           11,xz,11,xz,12,8,4,24,8,4,8,4,
                           12,12,xz,11,12,24,12,8,4,36,8,4,24,24,
                           12,12,6,6,6,12,24};
const int For_Elise[]={e4,me,e4,me,e4,b3,d4,c4,a3,
                       c3,e3,a3,b3,e3,le,b3,c4,e3,
                       e4,me,e4,me,e4,b3,d4,c4,a3,
                       c3,e3,a3,b3,e3,c4,b3,a3,
                       b3,c4,d4,e4,g3,f4,e4,d4,f3,e4,d4,c4,e3,d4,c4,b3,xz};
const int For_Elise_sus[]={6,6,6,6,6,6,6,6,18,
                       6,6,6,18,6,6,6,18,6,
                       6,6,6,6,6,6,6,6,18,
                       6,6,6,18,6,6,6,18,
                       6,6,6,18,6,6,6,18,6,6,6,6,6,6,6,18,6};
