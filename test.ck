3 => int range;
2 => int order;

int temp[range][Math.pow(range, order)$int];
<<< temp[0].size() >>>;

for (0 => int i; i < range; i++) {
    for (0 => int j; j < range; j++) {
        for (0 => int k; k < range; k++) {
            k => temp[i][j * k];
        }
    }
}
