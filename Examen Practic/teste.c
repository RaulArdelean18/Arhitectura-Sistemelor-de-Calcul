#include <stdio.h>

#define NMAX 1000
#define LMAX 256

extern int caracter(const char *word, char s, int m, int p);
extern int maxim(const int *v, int n);

int n, m, p;
char ch,mat[NMAX + 5][LMAX];
int cnt[NMAX + 5];

int main()
{
    ///in loc de assert am facut direct verificarea din citire (yeah maybe im crazy, but nu vreau sa imi crape fisierele si sa le rescriu (frumos cu antivirus))
    if (scanf(" %c", &ch) != 1)
        return 0;

    if (scanf("%d", &m) != 1)
        return 0;

    if (scanf("%d", &n) != 1 || n <= 0)
        return 0;

    for (int i = 1; i <= n; i++)
        if (scanf("%255s", mat[i]) != 1)
            return 0;

    if (scanf("%d", &p) != 1)
        return 0;

    for (int i = 1; i <= n; i++)
        cnt[i] = caracter(mat[i], ch, m, p);

    printf("\n");

    int mx = maxim(cnt + 1, n);
    printf("%d", mx);


    /// @debug 
    printf("\n \n------Aici ii zona de debug-------\n \n");

    for(int i=1;i<=n;i++)
        printf("%d ", cnt[i]);
    return 0;
}


/*
cd C:\[...]\repos\assembly

nasm modul1.asm -fwin32 -o modul1.obj
nasm modul2.asm -fwin32 -o modul2.obj
cl teste.c /link modul1.obj modul2.obj
teste.exe


+ 
4 
3
mere acte margarete
2
*/
