// SortNoise.ck
// Eric Heep

class SortNoise extends Chugen {

    1470 => int size;
    30 => int range;
    0.4 => float step;

    int chain[size];
    int prevChain[size];
    float values[range];

    // setters
    fun void setStep(float s) {
        s => step;
    }

    fun void setSize(int s) {
        s => size => chain.size;
    }

    fun void setRange(int r) {
        r => range => values.size;
    }

    // required
    fun void calculate() {
        for (0 => int i; i < size; i++) {
            Math.random2(0, range - 1) => chain[i];
        }
        for (0 => int i; i < range; i++) {
            //(0.5/range * i + 0.25/range) => values[i];
            Math.random2f(0.0, step) => values[i];
        }
    }

    fun int[] bubble(int arr[]) {
        1 => int flag;
        0 => int temp;
        arr.size() => int length;

        //for (1 => int i; i <= length; i++) {
            // if (flag) {
                0 => flag;

                for (0 => int j; j < length - 1; j++) {

                    if (values[arr[j + 1]] > values[arr[j]]) {
                        arr[j] => temp;
                        arr[j + 1] => arr[j];
                        temp => arr[j + 1];
                        1 => flag;
                    }
                }
            // }
        //}

        return arr;
    }

    fun void similarityReset() {
        0 => int ratio;
        for (0 => int i; i < size; i++) {
            if (prevChain[i] == chain[i]) {
                ratio++;
            }
        }
        <<< ratio/(size$float) >>>;
        if (ratio/size == 1) {
            for (0 => int i; i < size; i++) {
                Math.random2(0, range - 1) => chain[i];
            }
            for (0 => int i; i < range; i++) {
                //(0.5/range * i + 0.25/range) => values[i];
                Math.random2f(0, step) => values[i];
            }
        }
    }

    // sorts chain until it is sorted
    fun void sort() {
        0 => int pos;
        while (true) {
            (pos + 1) % size => pos;

            if (pos == 0) {
                chain @=> prevChain;
                bubble(chain) @=> chain;
                similarityReset();
            }
            1::samp => now;
        }
    }

    spork ~ sort();

    // reflects values back over thresholds
    fun float reflect(float in, float max, float min) {
        if (in > max) {
            return max - (in - max);
        }
        else if (in < min) {
            return min - (in - min);
        }
        else {
            return in;
        }
    }

    0 => int dir;
    0 => int tickPos;
    0.0 => float value;

    // tick, where the dsp happens
    fun float tick (float in) {
        values[chain[tickPos]] => float bump;
        (tickPos + 1) % size => tickPos;

        if (dir) {
            value + bump => value;
        }
        else {
            value - bump => value;
        }

        if (value > 1 || value < -1) {
            (dir + 1) % 2 => dir;
        }

        reflect(value, 1.0, -1.0) => value;

        return value;
    }
}


SortNoise nois => Pan2 pan1 => dac;
nois.setSize(520);
nois.setStep(0.1);
nois.setRange(13);
nois.calculate();

14::second => now;
