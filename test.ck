SinOsc sin => dac;
1::hour => now;
/*[0.1, -0.2, 0.4, 0.2, 0.3, -0.6] @=> float arr[];

fun float[] bubble(float arr[]) {
    1 => int flag;
    0 => float temp;
    arr.size() => int length;

    for (1 => int i; i <= length; i++) {
        if (flag) {
            0 => flag;

            for (0 => int j; j < length - 1; j++) {

                if (arr[j + 1] > arr[j]) {
                    arr[j] => temp;
                    arr[j + 1] => arr[j];
                    temp => arr[j + 1];
                    1 => flag;
                }
            }
        }
    }

    return arr;
}

bubble(arr) @=> arr;

<<< arr[0], arr[1], arr[2], arr[3], arr[4], arr[5] >>>;

void BubbleSort(apvector <int> &num)
{
      int i, j, flag = 1;    // set flag to 1 to start first pass
      int temp;             // holding variable
      int numLength = num.length( );
      for(i = 1; (i <= numLength) && flag; i++)
     {
          flag = 0;
          for (j=0; j < (numLength -1); j++)
         {
               if (num[j+1] > num[j])      // ascending order simply changes to <
              {
                    temp = num[j];             // swap elements
                    num[j] = num[j+1];
                    num[j+1] = temp;
                    flag = 1;               // indicates that a swap occurred.
               }
          }
     }
     return;   //arrays are passed to functions by address; nothing is returned
}
*/
