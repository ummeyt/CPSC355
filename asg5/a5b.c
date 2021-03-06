//Name: Ummey Zarin Tashnim
//ID: 30034931
//Professor: Leonard Manzara
//TA: Md. Reza Rabbani

//NOTE: if this was directly translated from C to Assembly, it is guaranteed to work.
#include<stdio.h>
#include<stdlib.h>

//input: ./myProg 12 25
//output: December 25th is Winter

int main(int argc, char *argv[])
{
  char *month[] = {"January", "Feb", "March", "April", "May", "June", "July",
		   "August", "September", "October", "November", "December"};
  char *season[] = {"Winter", "Spring", "Summer", "Fall"};

  int m = atoi(argv[1])-1;
  int d = atoi(argv[2]);

  printf("%s ", month[m]);

  if (d == 3 || d == 23)
    printf("%drd", d);

  else if (d == 1 || d == 21 || d == 31)
    printf("%dst", d);

  else if (d == 2 || d == 22)
    printf("%dnd", d);

  else
    printf("%dth", d);

  if ((m == 2 && d >= 20) || (m == 5 && d >= 21) ||
      (m == 8 && d >= 22) || (m == 11 && d >= 21))
    m += 1;                                           //add one to month
  printf(" is %s\n", season[(m/3)%4]);	

  return 0;
}
