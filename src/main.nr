use dep::std;

const nEntities: Field = 10;
const nTicks: Field = 1000;

const SPEED: Field = 10;

// tier zero: no events
// just tick
fn main() {
    let mut xs : [Field; nEntities] = [0; 10];
    let mut ys : [Field; nEntities] = [0; 10];

    for _i in 0..nTicks {
        for j in 0..nEntities {
            xs[j] = xs[j] + SPEED;
            ys[j] = ys[j] + SPEED;
        }
    };
}
