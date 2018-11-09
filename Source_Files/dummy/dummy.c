#include <stdio.h>
#include <stdlib.h>
#include <time.h>

#define N 512

void ijk(float (*a)[N], float (*b)[N], float (*c)[N], int n) {

    int i, j, k;
    float sum;

    for (i = 0; i < n; i++) {
        for (j = 0; j < n; j++) {

            sum = 0.0;

            for (k = 0; k < n; k++)
                sum += a[i][k] * b[k][j];

            c[i][j] = sum;

        }
    }
}



void initVal(float (*ret)[N], float val, int n) {

    int i, j;

    for (i = 0; i < n; i++) {
        for (j = 0; j < n; j++) {
            ret[i][j] = val;
        }
    }

}

void initRandom(float (*ret)[N], int n) {

    int i, j;

    srand((unsigned int) time(NULL));

    for (i = 0; i < n; i++) {

        for (j = 0; j < n; j++) {
            ret[i][j] = (float) rand() / (float) (RAND_MAX / 1000); // limite = 1000
        }
    }

}

int main() {

    float (*matA)[N] = malloc(sizeof (float) * N * N);
    float (*matB)[N] = malloc(sizeof (float) * N * N);
    float (*matC)[N] = malloc(sizeof (float) * N * N);
    
    //int i, j;

    initRandom(matA, N);
    initVal(matB, 1, N);
    initVal(matC, 0, N);

    ijk(matA, matB, matC, N);

    /*for (i = 0; i < N; i++) {
        for (j = 0; j < N; j++) {
            printf("%f ", matC[i][j]);
        }
        printf("\n");
    }*/

    return 0;

}

