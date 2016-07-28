NanoKontrol2 nano;

2 => int NUM;

// MarkovNoise markov[NUM];
SortNoise sort[NUM];
RapidNoise rapid[NUM];

Pan2 markovPan[NUM];
Pan2 sortPan[NUM];
Pan2 rapidPan[NUM];

for (0 => int i; i < NUM; i++) {
    /*markov[i].setStep(0.1);
    markov[i].setRange(6);
    markov[i].setSize(1000);
    markov[i].setOrder(1);
    markov[i].calculate();

    spork ~ markov[i].feedback();

    markov[i] => markovPan[i] => dac;;*/
    sort[i].setSize(1520);
    sort[i].setStep(0.1);
    sort[i].setRange(13);
    sort[i].calculate();

    rapid[i].setSize(1520);
    rapid[i].setStep(0.1);
    rapid[i].setRange(13);
    rapid[i].calculate();

    sort[i] => sortPan[i] => dac;
    rapid[i] => rapidPan[i] => dac;
}

while (true) {
    10::ms => now;
}
