NanoKontrol2 nano;

2 => int NUM;

MarkovNoise markov[NUM];
SortNoise sort[NUM];
RapidNoise rapid[NUM];

Pan2 markovPan[NUM];
Pan2 sortPan[NUM];
Pan2 rapidPan[NUM];

for (0 => int i; i < NUM; i++) {

    markov[i].setStep(0.1);
    markov[i].setRange(6);
    markov[i].setSize(1000);
    markov[i].setOrder(1);
    markov[i].calculate();

    spork ~ markov[i].feedback();

    markov[i] => markovPan[i] => dac;;
    sort[i] => sortPan[i] => dac;
    rapid[i] => rapidPan[i] => dac;
}

// feeds chain back into transition matrix to create a new chain,
// then creates a new transition matrix from that chain
/*fun void markovFeedback() {
    0 => int pos;
    while (true) {
        (pos + 1) % size => pos;

        if (pos == 0) {
            chain @=> prevChain;
            markov.generateChain(chain, transitionMatrix, order, range) @=> chain;
            markov.generateTransitionMatrix(chain, order, range) @=> transitionMatrix;
            similarityReset();
        }
        1::samp => now;
    }
}*/


while (true) {
    10::ms => now;
}
