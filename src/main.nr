use dep::std;

const nEntities: Field = 10;
const nTicks: Field = 100;

// Non-euclidean geometries are easier to prove :)
fn manhattan_distance(x1: Field, x2: Field, y1: Field, y2: Field) -> Field {
    (x1 - x2) + (y1 - y2)
}

// An RTS game, written completely in Noir. 
// Each tick: 
// - entities move towards their respective "goal" position, at a rate of `SPEED`.
// - entities with nonzero health (ie. alive), damage every other entity within `RANGE` of them.
// - the player sets a new goal position for exactly one entity.
//
// Movement based on https://gamedev.stackexchange.com/questions/50978/moving-a-sprite-towards-an-x-and-y-coordinate
fn simulate_rts(selected : [Field; nTicks], newGoalsX : [Field; nTicks], newGoalsY : [Field; nTicks]) {
    // Entity traits
    let speeds : [Field; nEntities] = [5; 10];
    let ranges : [Field; nEntities] = [12; 10];
    let mut healths : [Field; nEntities] = [0; 10];
    let mut xs : [Field; nEntities] = [0; 10];
    let mut ys : [Field; nEntities] = [0; 10];
    let mut xGoals : [Field; nEntities] = [1; 10];
    let mut yGoals : [Field; nEntities] = [1; 10];

    for i in 0..nTicks {
        for j in 0..nEntities {
            // If the player has selected this entity, update its goal position
            if selected[i] == j {
                xGoals[j] = newGoalsX[i];
                yGoals[j] = newGoalsY[j];
            }

            // Move entity towards its goal position
            let run = xGoals[j] - xs[j];
            let rise = yGoals[j] - ys[j];
            let length = run + rise;
            let unitX = run / length;
            let unitY = rise / length;

            xs[j] = unitX * speeds[j];
            ys[j] = unitY * speeds[j];

            // If this entity is alive, damage all other entities within `RANGE`
            for k in 0..nEntities {
                if (j != k) & (healths[j] != 0) & (manhattan_distance(xs[j], xs[k], ys[j], ys[k]) < ranges[j]) {
                    healths[k] = healths[k] - 1;
                }
            }
        }
    };
}

fn main() {
    // Default values to mimic player input
    let selected : [Field; nTicks] = [0; 100];
    let newGoalsX : [Field; nTicks] = [9999; 100];
    let newGoalsY : [Field; nTicks] = [9999; 100];

    simulate_rts(selected, newGoalsX, newGoalsY);
}
