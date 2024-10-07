#include <stdio.h>

int main() { 
  char first = 'a';
  int count = 0;
  for (int i = 0; i < 26;++i){
    printf("%c", first);
    ++first;
    ++count;
    if(count == 13){
      printf("\n");
    }
  }

  return 0;
}