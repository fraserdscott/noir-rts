use dep::std;

const nEntities: Field = 10;
const nTicks: Field = 1000;

const SPEED: Field = 10;

// Move entities towards their goal tile each tick, at a certain speed
// Inspired by https://gamedev.stackexchange.com/questions/50978/moving-a-sprite-towards-an-x-and-y-coordinate
fn main() {
    let mut xs : [Field; nEntities] = [0; 10];
    let mut ys : [Field; nEntities] = [0; 10];

    let goalsX : [Field; nEntities] = [9999999; 10];
    let goalsY : [Field; nEntities] = [9999999; 10];

    for _i in 0..nTicks {
        for j in 0..nEntities {
            let run = goalsX[j] - xs[j];
            let rise = goalsY[j] - ys[j];
            let length = run + rise;
            let unitX = run / length;
            let unitY = rise / length;

            xs[j] = unitX * SPEED;
            ys[j] = unitY * SPEED;
        }
    };
}
