use dep::std;

const nEntities: Field = 10;
const nTicks: Field = 10;
const SIZE: Field = 5;
const DAMAGE: Field = 1;

// Non-euclidean geometries are easier to prove :)
fn manhattan_distance(x1: Field, x2: Field, y1: Field, y2: Field) -> Field {
    (x1 - x2) + (y1 - y2)
}

// An RTS game, written completely in Noir. 
// Each tick: 
// - entities move towards their respective "goal" position, at a rate of `SPEED`.
// - entities with nonzero health (ie. alive), damage every entity that is not in their faction and within `RANGE` of them.
// - the player sets a new goal position for exactly one entity.
//
// Movement based on https://gamedev.stackexchange.com/questions/50978/moving-a-sprite-towards-an-x-and-y-coordinate
fn simulate_rts(
    factions : [Field; nEntities],
    initialXs : [Field; nEntities],
    initialYs : [Field; nEntities],
    initialHealths : [Field; nEntities],
    ranges : [Field; nEntities],
    speeds : [Field; nEntities],
    selected : [Field; nTicks], 
    newGoalsX : [Field; nTicks], 
    newGoalsY : [Field; nTicks],
    ) {

    // Entity traits
    let mut healths : [Field; nEntities] = [0; 10];
    let mut xs : [Field; nEntities] = [0; 10];
    let mut ys : [Field; nEntities] = [0; 10];
    let mut xGoals : [Field; nEntities] = [0; 10];
    let mut yGoals : [Field; nEntities] = [0; 10];

    for i in 0..nEntities {
        healths[i] = initialHealths[i];
        xs[i] = initialXs[i];
        ys[i] = initialYs[i];
    };

    for i in 0..nTicks {
        for j in 0..nEntities {
            // If the player has selected this entity, update its goal position
            if selected[i] == j {
                xGoals[j] = newGoalsX[i];
                yGoals[j] = newGoalsY[j];
            }
            
            // Calculate move towards its goal position
            let run = xGoals[j] - xs[j];
            let rise = yGoals[j] - ys[j];
            let length = run + rise;

            if length != 0 {
                let unitX = run / (length + 1);
                let unitY = rise / (length + 1);
                let newX = unitX * speeds[j];
                let newY = unitY * speeds[j];

                // Check if the new position collides with another entity
                let mut found = false;
                for k in 0..nEntities {
                    if manhattan_distance(newX, xs[k], newY, ys[k]) < SIZE {
                        found = true;
                    }
                };

                if !found {
                    xs[j] = newX;
                    ys[j] = newY;
                }
            }

            // If this entity is alive, damage all enemy entities within `RANGE`
            for k in 0..nEntities {
                if (healths[j] != 0) & (factions[j] != factions[k]) & (manhattan_distance(xs[j], xs[k], ys[j], ys[k]) < ranges[j]) {
                    healths[k] = healths[k] - DAMAGE;
                }
            }
        }
    };
}

fn main() {
    // The match configuration; immutable entity traits
    let factions : [Field; nEntities] = [0; 10];
    let initialHealths : [Field; nEntities] = [200; 10];
    let ranges : [Field; nEntities] = [10; 10];
    let speeds : [Field; nEntities] = [2; 10];
    let mut initialXs : [Field; nEntities] = [0; 10];
    let mut initialYs : [Field; nEntities] = [0; 10];

    // Spawn entities in a line along the bottom of the map
    for i in 0..nEntities {
        initialXs[i] = i * 100;
    };

    // Default values to mimic player input
    let selected : [Field; nTicks] = [0; 10];
    let newGoalsX : [Field; nTicks] = [0; 10];
    let newGoalsY : [Field; nTicks] = [0; 10];

    simulate_rts(factions, initialXs, initialYs, initialHealths, ranges, speeds, selected, newGoalsX, newGoalsY);
}
