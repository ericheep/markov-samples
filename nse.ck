NanoKontrol2 nano;

2 => int NUM;

MarkovNoise markov[NUM];
SortNoise sort[NUM];
RapidNoise rapid[NUM];

Gain markovGain[NUM];
Gain sortGain[NUM];
Gain rapidGain[NUM];

Pan2 markovPan[NUM];
Pan2 sortPan[NUM];
Pan2 rapidPan[NUM];

WinFuncEnv rapidEnv[NUM];
WinFuncEnv sortEnv[NUM];

[4, 5] @=> int markovLocation[];
float markovStep[NUM];
float markovGainFloat[NUM];
float markovGainInt[NUM];

0.004 => float rapidIncrement;
[0, 1] @=> int rapidLocation[];
int rapidRatioInt[NUM];
int rapidSLatch[NUM];
int rapidMLatch[NUM];
float rapidStep[NUM];
float rapidRatioFloat[NUM];
float rapidGainFloat[NUM];
float rapidGainInt[NUM];

10.0::second => dur rapidAttack;
10.0::second => dur rapidRelease;

[2, 3] @=> int sortLocation[];
int sortSLatch[NUM];
int sortMLatch[NUM];
int sortMaxSize[NUM];
float sortStep[NUM];
float sortRatioFloat[NUM];
float sortGate[NUM];
dur sortAttack[NUM];
dur sortRelease[NUM];
float sortGainFloat[NUM];
float sortGainInt[NUM];

float gateRate;

for (0 => int i; i < NUM; i++) {
    markovGain[i].gain(0.0);
    markov[i].setStep(0.1);
    markov[i].setRange(5);
    markov[i].setSize(150);
    markov[i].setOrder(1);
    markov[i].calculate();
    markov[i] => markovGain[i] => markovPan[i] => dac;;

    1::second => sortAttack[i];
    1::second => sortRelease[i];
    sort[i].setMaxSize(1520);
    sort[i].setStep(0.1);
    sort[i].setRange(13);
    sort[i].calculate();
    sort[i] => sortGain[i] => sortEnv[i] => sortPan[i] => dac;
    sortEnv[i].keyOff();

    rapidGain[i].gain(0.0);
    rapidEnv[i].attack(rapidAttack);
    rapidEnv[i].release(rapidRelease);
    rapid[i].setMaxSize(8520);
    rapid[i].setRatioSize(1.0);
    rapid[i].setStep(0.004);
    rapid[i].setRange(13);
    rapid[i].calculate();
    rapid[i] => rapidGain[i] => rapidEnv[i] => rapidPan[i] => dac;
    rapidEnv[i].keyOn();
}

fun void rapidControl() {
    for (0 => int i; i < NUM; i++) {
        nano.knob[rapidLocation[i]] => rapidGainInt[i];
        nano.slider[rapidLocation[i]] => rapidRatioInt[i];

        if (nano.s[rapidLocation[i]] && rapidSLatch[i] == 0) {
            rapidIncrement +=> rapidStep[i];
            Std.clampf(rapidStep[i], 0.001, 1.0) => rapidStep[i];
            spork ~ rapidEnvelope(i);
            1 => rapidSLatch[i];
        }
        if (nano.s[rapidLocation[i]] == 0 && rapidSLatch[i] == 1) {
            0 => rapidSLatch[i];
        }

        if (nano.m[rapidLocation[i]] && rapidMLatch[i] == 0) {
            rapidIncrement -=> rapidStep[i];
            Std.clampf(rapidStep[i], 0.001, 1.0) => rapidStep[i];
            spork ~ rapidEnvelope(i);
            1 => rapidMLatch[i];
        }
        if (nano.m[rapidLocation[i]] == 0 && rapidMLatch[i] == 1) {
            0 => rapidMLatch[i];
        }
    }
}

fun void sortControl() {
    for (0 => int i; i < NUM; i++) {
        nano.knob[sortLocation[i]] => sortGainInt[i];
        ((nano.slider[sortLocation[i]] / 127.0 * -1.0 + 1.0) * 4000)
        $int + 10 => sortMaxSize[i];

        if (nano.s[sortLocation[i]] && sortSLatch[i] == 0) {
            1 => sortSLatch[i];
            spork ~ sortEnvelope(i);
        }
        if (nano.s[sortLocation[i]] == 0 && sortSLatch[i] == 1) {
            0 => sortSLatch[i];
        }

        if (nano.m[sortLocation[i]] && sortMLatch[i] == 0) {
            1 => sortMLatch[i];
        }
        if (nano.m[sortLocation[i]] == 0 && sortMLatch[i] == 1) {
            0 => sortMLatch[i];
        }
    }
}

fun void markovControl() {
    for (0 => int i; i < NUM; i++) {
        nano.knob[markovLocation[i]] => markovGainInt[i];
        (nano.slider[markovLocation[i]] / 127.0 * 0.4) + 0.02 => markovStep[i];
        markov[i].setStep(markovStep[i]);
    }
}
fun void rapidEnvelope(int idx) {
    rapidEnv[idx].keyOff();
    rapidRelease => now;
    rapid[idx].setStep(rapidStep[idx]);
    rapid[idx].calculate();
    rapidEnv[idx].keyOn();
}

fun void sortEnvelope(int idx) {
    Math.random2f(5.0, 7.0)::second => sortAttack[idx];
    Math.random2f(5.0, 7.0)::second => sortRelease[idx];

    sortEnv[idx].attack(sortAttack[idx]);
    sortEnv[idx].release(sortRelease[idx]);

    sortEnv[idx].keyOff();
    sortRelease[idx] => now;
    sort[idx].setMaxSize(sortMaxSize[idx]);
    sort[idx].calculate();
    sortEnv[idx].keyOn();
}

fun void easing() {
    0.0001 => float increment;
    0.00025 => float gainIncrement;
    for (0 => int i; i < NUM; i++) {
        if (rapidRatioInt[i]/127.0 > rapid[i].ratioSize) {
            rapidRatioFloat[i] + increment => rapidRatioFloat[i];
        }
        else {
            rapidRatioFloat[i] - increment => rapidRatioFloat[i];
        }
        rapid[i].setRatioSize(rapidRatioFloat[i]);

        // rapid easing
        if (rapidGainInt[i]/127.0 > rapidGainFloat[i]) {
            rapidGainFloat[i] + gainIncrement => rapidGainFloat[i];
        }
        else {
            rapidGainFloat[i] - gainIncrement => rapidGainFloat[i];
        }
        rapidGain[i].gain(Std.clampf(rapidGainFloat[i], 0.0, 1.0));

        // sort easing
        if (sortGainInt[i]/127.0 > sortGainFloat[i]) {
            sortGainFloat[i] + gainIncrement => sortGainFloat[i];
        }
        else {
            sortGainFloat[i] - gainIncrement => sortGainFloat[i];
        }
        sortGain[i].gain(Std.clampf(sortGainFloat[i], 0.0, 1.0));

        // sort markov
        if (markovGainInt[i]/127.0 > markovGainFloat[i]) {
            markovGainFloat[i] + gainIncrement => markovGainFloat[i];
        }
        else {
            markovGainFloat[i] - gainIncrement => markovGainFloat[i];
        }
        markovGain[i].gain(Std.clampf(markovGainFloat[i], 0.0, 1.0));
    }
}

fun void sortGating(int idx) {
    Math.random2f(4.0, 5.0)::second => dur gateMax;
    1.0::second => dur gateTime;
    while (true) {
        Math.pow(gateRate, 3) * gateMax + 20::ms => gateTime;
        if (gateRate > 0) {
            gateTime => now;
            sort[idx].gain(0.0);
            gateTime => now;
            sort[idx].gain(1.0);
        }
        1::samp => now;
    }
}

fun void rapidGating(int idx) {
    Math.random2f(4.0, 5.0)::second => dur gateMax;
    1.0::second => dur gateTime;
    while (true) {
        Math.pow(gateRate, 3) * gateMax + 50::ms => gateTime;
        if (gateRate > 0) {
            gateTime => now;
            rapid[idx].gain(0.0);
            gateTime => now;
            rapid[idx].gain(1.0);
        }
        1::samp => now;
    }
}

fun void markovGating(int idx) {
    Math.random2f(4.0, 5.0)::second => dur gateMax;
    1.0::second => dur gateTime;
    while (true) {
        Math.pow(gateRate, 3) * gateMax + 50::ms => gateTime;
        if (gateRate > 0) {
            gateTime => now;
            markov[idx].gain(0.0);
            gateTime => now;
            markov[idx].gain(1.0);
        }
        1::samp => now;
    }
}

fun void gateControl() {
    nano.knob[7] / 127.0 => gateRate;
}

0.001 => float sortIncrement;
0.0 => float sortTotal;

fun void sortPanning() {
    (sortIncrement + sortTotal) % (2 * pi) => sortTotal;
    for (0 => int i; i < NUM; i++) {
        if (i == 0) {
            sortPan[i].pan(Math.sin(sortTotal) * 0.4);
        }
        else {
            sortPan[i].pan(-Math.sin(sortTotal) * 0.4);
        }
    }
}

0.0015 => float rapidInc;
0.0 => float rapidTotal;

fun void rapidPanning() {
    (rapidInc + rapidTotal) % (2 * pi) => rapidTotal;
    for (0 => int i; i < NUM; i++) {
        if (i == 0) {
            rapidPan[i].pan(Math.sin(rapidTotal) * 0.2);
        }
        else {
            rapidPan[i].pan(-Math.sin(rapidTotal) * 0.2);
        }
    }
}

0.0025 => float markovInc;
0.0 => float markovTotal;

fun void markovPanning() {
    (markovInc + markovTotal) % (2 * pi) => markovTotal;
    for (0 => int i; i < NUM; i++) {
        if (i == 0) {
            markovPan[i].pan(Math.sin(markovTotal) * 0.8);
        }
        else {
            markovPan[i].pan(-Math.sin(markovTotal) * 0.8);
        }
    }
}

for (int i; i < NUM; i++) {
    spork ~ sortGating(i);
    spork ~ rapidGating(i);
    spork ~ markovGating(i);
}

while (true) {
    markovControl();
    rapidControl();
    sortControl();

    markovPanning();
    rapidPanning();
    sortPanning();

    gateControl();

    easing();
    10::ms => now;
}
