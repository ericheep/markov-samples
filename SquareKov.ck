
class SquareKov extends Chugen {

    40 => int size;
    0 => int position;

    fun float tick (float in) {
        (position + 1) % size => position;
        return in;
    }
}

SquareKov sqr => dac;

while (true) {
    1::second => now;
}
