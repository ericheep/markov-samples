// RapidNoise.ck
// Eric Heep

public class RapidNoise extends Chugen {

    1470 => int size;
    30 => int range;
    0.4 => float step;

    int chain[size];
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

/*
RapidNoise nois => Pan2 pan1 => dac;
nois.setSize(22050);
nois.setStep(0.01);
nois.setRange(13);
nois.calculate();

4::second => now;
nois.calculate();
4::second => now;
nois.calculate();
4::second => now;
nois.calculate();
4::second => now;
*/

