#include<stdio.h>
#include<stdlib.h>

#define N 10 /// order of the filter
#define NT (N+1) /// number of coeffs
#define NB 10 /// number of bits
#define SHAMT 11 /// shift amount

const int bi[NT]={-1,-7,-13,32,140,203,140,32,-13,-7,-1}; /// b array
const int ai[NT-1]={0, 0}; /// a array

/// Perform fixed point filtering assming direct form I
///\param x is the new input sample
///\return the new output sample

int * myfilter(int *x)
{
  static int sx[2][3];
  static int sx0[2];
  static int sx1[2];
  static int sx2[3]; /// x shift register
  static int sy[2][NT-1]; /// y shift register
  static int first_run = 0; /// for cleaning shift registers
  int i; /// index
  int y[3]; /// output sample

  /// clean the buffers
  if (first_run == 0)
  {
    first_run = 1;
    for (i=0; i<3; i++){
      sx[0][i] = 0;
    }
        for (i=0; i<3; i++){
      sx[1][i] = 0;
    }
        for (i=0; i<4; i++){
      sx[2][i] = 0;
    }
    for (size_t j = 0; i < 2; j++)
    {
    for (i=0; i<NT-1; i++)
      sy[j][i] = 0;
    }
    

  }

  /// shift and insert new sample in x shift register
  for (i=2; i>0; i--)
    sx[0][i] = sx[0][i-1];
  sx[0][0] = x[0];

  for (i=2; i>0; i--)
    sx[1][i] = sx[1][i-1];
  sx[1][0] = x[1];

  for (i=3; i>0; i--)
    sx[2][i] = sx[2][i-1];
  sx[2][0] = x[2];
  /// make the convolution
  /// Moving average part
  for (size_t i = 0; i < 3; i++)
  {
    y[i]=0;
  }
  
  
    y[0] += ((sx[0][0]*bi[0]) >> SHAMT) << (SHAMT-NB+1);
    y[0] += ((sx[2][1]*bi[1]) >> SHAMT) << (SHAMT-NB+1);
    y[0] += ((sx[1][1]*bi[2]) >> SHAMT) << (SHAMT-NB+1);
    y[0] += ((sx[0][1]*bi[3]) >> SHAMT) << (SHAMT-NB+1);
    y[0] += ((sx[2][2]*bi[4]) >> SHAMT) << (SHAMT-NB+1);
    y[0] += ((sx[1][2]*bi[5]) >> SHAMT) << (SHAMT-NB+1);
    y[0] += ((sx[0][2]*bi[6]) >> SHAMT) << (SHAMT-NB+1);
    y[0] += ((sx[2][3]*bi[7]) >> SHAMT) << (SHAMT-NB+1);
    y[0] += ((sx[1][3]*bi[8]) >> SHAMT) << (SHAMT-NB+1);
    y[0] += ((sx[0][3]*bi[9]) >> SHAMT) << (SHAMT-NB+1);
    y[0] += ((sx[2][4]*bi[10]) >> SHAMT) << (SHAMT-NB+1);
    
    y[1] += ((sx[1][0]*bi[0]) >> SHAMT) << (SHAMT-NB+1);
    y[1] += ((sx[0][0]*bi[1]) >> SHAMT) << (SHAMT-NB+1);
    y[1] += ((sx[2][1]*bi[2]) >> SHAMT) << (SHAMT-NB+1);
    y[1] += ((sx[1][1]*bi[3]) >> SHAMT) << (SHAMT-NB+1);
    y[1] += ((sx[0][1]*bi[4]) >> SHAMT) << (SHAMT-NB+1);
    y[1] += ((sx[2][2]*bi[5]) >> SHAMT) << (SHAMT-NB+1);
    y[1] += ((sx[1][2]*bi[6]) >> SHAMT) << (SHAMT-NB+1);
    y[1] += ((sx[0][2]*bi[7]) >> SHAMT) << (SHAMT-NB+1);
    y[1] += ((sx[2][3]*bi[8]) >> SHAMT) << (SHAMT-NB+1);
    y[1] += ((sx[1][3]*bi[9]) >> SHAMT) << (SHAMT-NB+1);
    y[1] += ((sx[0][3]*bi[10]) >> SHAMT) << (SHAMT-NB+1);

    y[2] += ((sx[2][0]*bi[0]) >> SHAMT) << (SHAMT-NB+1);
    y[2] += ((sx[1][0]*bi[1]) >> SHAMT) << (SHAMT-NB+1);
    y[2] += ((sx[0][0]*bi[2]) >> SHAMT) << (SHAMT-NB+1);
    y[2] += ((sx[2][1]*bi[3]) >> SHAMT) << (SHAMT-NB+1);
    y[2] += ((sx[1][1]*bi[4]) >> SHAMT) << (SHAMT-NB+1);
    y[2] += ((sx[0][1]*bi[5]) >> SHAMT) << (SHAMT-NB+1);
    y[2] += ((sx[2][2]*bi[6]) >> SHAMT) << (SHAMT-NB+1);
    y[2] += ((sx[1][2]*bi[7]) >> SHAMT) << (SHAMT-NB+1);
    y[2] += ((sx[0][2]*bi[8]) >> SHAMT) << (SHAMT-NB+1);
    y[2] += ((sx[2][3]*bi[9]) >> SHAMT) << (SHAMT-NB+1);
    y[2] += ((sx[1][3]*bi[10]) >> SHAMT) << (SHAMT-NB+1);


  
  
  /// update the y shift register
  for (i=NT-2; i>0; i--)
    sy[0][i] = sy[0][i-1];
  sy[0][0] = y[0];
 
   for (i=NT-2; i>0; i--)
    sy[1][i] = sy[1][i-1];
  sy[1][0] = y[1];

   for (i=NT-2; i>0; i--)
    sy[2][i] = sy[2][i-1];
  sy[2][0] = y[2];
  return y;
}

int main (int argc, char **argv)
{
  FILE *fp_in;
  FILE *fp_out;

  int x[2];
  int y[2];

  /// check the command line
  if (argc != 3)
  {
    printf("Use: %s <input_file> <output_file>\n", argv[0]);
    exit(1);
  }
  
  /// open files
  fp_in = fopen(argv[1], "r");
  if (fp_in == NULL)
  {
    printf("Error: cannot open %s\n", argv[1]);
    exit(2);
  }
  fp_out = fopen(argv[2], "w");

  /// check shift amount
  if (SHAMT < ((NB)-1))
  {
    printf("Error shift amount must be at least nbit-1\n");
    exit(3);
  }

  /// get samples and apply filter
  fscanf(fp_in, "%d", &x[0]);
  fscanf(fp_in, "%d", &x[1]);
  fscanf(fp_in, "%d", &x[2]);
  do{
    *y = myfilter(x);
    for (size_t i = 0; i < 3; i++)
    {
      fprintf(fp_out,"%d\n", y[i]);
    }
    
    fprintf(fp_out,"%d\n", y);
  fscanf(fp_in, "%d", &x[0]);
  fscanf(fp_in, "%d", &x[1]);
  fscanf(fp_in, "%d", &x[2]);
  } while (!feof(fp_in));

  fclose(fp_in);
  fclose(fp_out);

  return 0;

}
