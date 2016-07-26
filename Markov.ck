// Markov.ck

public class Markov {

    0 => int currentRow;

    int combinations[0][0];

    fun void generateCombinations(int order, int range) {
        if (order == 1) {
            int temp[Math.pow(range, order)$int][order];
            for (0 => int j; j < temp.size(); j++) {
                j % range => temp[j][0];
            }
            temp @=> combinations;
        }
        if (order == 2) {
            int temp[Math.pow(range, order)$int][order];
            for (0 => int i; i < order; i++) {
                for (0 => int j; j < temp.size(); j++) {
                    if (i == 0) {
                        j / range => temp[j][i];
                    }
                    if (i == 1) {
                        j % range => temp[j][i];
                    }
                }
            }
            temp @=> combinations;
        }
        /*if (order == 3) {
            int temp[range][range][range];
            for (0 => int i; i < range; i++) {
                for (0 => int j; j < range; j++) {
                    for (0 => int k; k < range; k++) {
                        k @=> temp[i][j * k];
                    }
                }
            }
            temp @=> combinations;
        }
        */
    }

    fun int[] generateChain(int inputChain[], float transitionMatrix[][], int order, int range) {
        /* Calculates an output chain based on the input and its probabilities.

        Parameters
        ----------
        inputChain : int array
            input chain that the output will be created from
        transitionMatrix : two dimensional float array
            collection of probabilities
        order : int
            Markov chain order
        range : int
            range of values that can be considered

        Returns
        -------
        outputChain : int array
            output chain
        */

        inputChain.size() => int length;
        int outputChain[length];

        // a new link for length of the array
        for (0 => int j; j < length; j++) {
            int row;

            // finds row index
            for (0 => int i; i < order; i++) {
               inputChain[(length - order + i + j) % length] => int element;
               (Math.pow(range, order - i - 1) * element) $ int +=> row;
            }

            // finds range of values
            float sum;
            for (0 => int i; i < range; i++) {
                transitionMatrix[row][i] +=> sum;
            }

            Math.random2f(0.0, sum) => float randomValue;

            // finds our next link for the chain
            0.0 => sum;
            for (0 => int i; i < range; i++) {
                transitionMatrix[row][i] +=> sum;
                if (randomValue < sum) {
                    i => outputChain[j];
                    break;
                }
            }
        }

        return outputChain;
    }

    fun float[][] generateTransitionMatrix(int inputChain[], int order, int range) {
        /* Generates transition matrix from a chain.

        Parameters
        ----------
        inputChain : int array
            input chain that the output will be created from
        order : int
            Markov chain order
        range : int
            range of values that can be considered

        Returns
        -------
        outputChain : int array
            output chain
        */

        inputChain.size() => int length;
        Math.pow(range, order)$int => int rows;

        float transitionMatrix[rows][range];

        int element[range];
        int current[range];

        for (0 => int i; i < range; i++) {
            i => element[i];
        }

        int combination[range];
        0 => currentRow;

        for (0 => int i; i < combinations.size(); i++) {
            for (int j; j < order; j++) {
                combinations[i][j] => combination[j];
            }

            int matches[0];

            // checks if current combination is in input chain
            for (0 => int j; j < length; j++) {
                0 => int matchSum;

                for (0 => int k; k < order; k++) {
                    if (inputChain[(length - order + k + j) % length] == combination[k]) {
                        1 +=> matchSum;
                    }
                }

                if (matchSum == order) {
                   matches << inputChain[j];
                }
            }
            matches.size() => int size;
            for (0 => int j; j < size; j++) {
                1.0/size +=> transitionMatrix[i][matches[j]];
            }
        }

        return transitionMatrix;
    }
}

/*
Markov markov;
SinOsc sin => dac;

4 => int range;
1 => int order;

[0, 1, 3, 1, 2, 1, 2, 0, 2, 1, 2, 3, 2] @=> int base[];
base @=> int chain[];

// markov.generateChain(chain, transitionMatrix, order, range) @=> chain;
markov.generateCombinations(order, range);
markov.generateTransitionMatrix(base, order, range) @=> float transitionMatrix[][];

fun string print(int arr[]) {
    string print;
    for (0 => int i; i < arr.size(); i++) {
        print + " " + arr[i] => print;
    }
    <<< print, "" >>>;
}


while (true) {
    print(chain);
    for (0 => int i; i < chain.size(); i++) {
        sin.freq(Std.mtof(chain[i] + 60));
        50::ms => now;
    }
    markov.generateChain(base, transitionMatrix, order, range) @=> chain;
}
