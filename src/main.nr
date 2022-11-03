use dep::std;

const nFactions: Field = 2;
const nUnits: Field = 10;
const nTicks: Field = 10;
const SIZE: Field = 5;
const DAMAGE: Field = 1;

// Non-euclidean geometries are easier to prove :)
fn manhattan_distance(x1: Field, x2: Field, y1: Field, y2: Field) -> Field {
    (x1 - x2) + (y1 - y2)
}

fn out_range(x: Field, y: Field, xs: [Field], ys: [Field]) -> bool {
    let mut found = false;
    for i in 0..std::array::len(xs) {
        if manhattan_distance(x, xs[i], y, ys[i]) < SIZE {
            found = true;
        }
    };
    !found
}

fn find_max_index(l: [Field]) -> Field {
    let mut maxIndex = 0;
    let mut maxValue = 0;
    for i in 0..std::array::len(l) {
        if l[i] > maxValue {
            maxIndex = i;
            maxValue = l[i];
        }
    };
    maxIndex
}

// An Noir RTS game.
// Each tick: 
// - units move towards their respective "goal" position, at a rate of `SPEED`.
// - units with nonzero health (ie. alive), damage every unit that is not in their faction and within `RANGE` of them.
// - the player sets a new goal position for exactly one unit.
//
// Movement based on https://gamedev.stackexchange.com/questions/50978/moving-a-sprite-towards-an-x-and-y-coordinate
fn simulate_rts(
    factions : [Field; nUnits], // The faction of each unit
    initialXs : [Field; nUnits], // The starting x for each unit
    initialYs : [Field; nUnits], // The starting y for each unit
    initialHealths : [Field; nUnits], // The initial health of each unit
    ranges : [Field; nUnits], // The attack range of each unit
    speeds : [Field; nUnits], // The movement speed of each unit
    selected : [Field; nTicks], // The selected unit per tick
    newGoalsX : [Field; nTicks], // The goal x of the selected unit per tick
    newGoalsY : [Field; nTicks], // The goal y of the selected unit per tick
    ) -> [Field; 2] {

    // Mutable unit traits
    let mut healths : [Field; nUnits] = [0; 10];
    let mut xs : [Field; nUnits] = [0; 10];
    let mut ys : [Field; nUnits] = [0; 10];
    let mut xGoals : [Field; nUnits] = [0; 10];
    let mut yGoals : [Field; nUnits] = [0; 10];

    for i in 0..nUnits {
        healths[i] = initialHealths[i];
        xs[i] = initialXs[i];
        ys[i] = initialYs[i];
    };

    for i in 0..nTicks {
        for j in 0..nUnits {
            // If the player has selected this unit, update its goal position
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

                // Check if the new position collides with any another unit
                if out_range(newX, newY, xs, ys) {
                    xs[j] = newX;
                    ys[j] = newY;
                }
            }

            // If this unit is alive, damage all enemy entities within range
            for k in 0..nUnits {
                if (healths[j] > 0) & (factions[j] != factions[k]) & (manhattan_distance(xs[j], xs[k], ys[j], ys[k]) < ranges[j]) {
                    healths[k] = healths[k] - DAMAGE;
                }
            }
        }
    };

    // Whichever faction has most overall unit health wins
    let mut points : [Field; nFactions] = [0 ; 2];
    for i in 0..nUnits {
        let mut faction = 0;
        for j in 0..nFactions {
            if j == factions[i] {
                faction = j;
            }
        };
        points[faction] = points[faction] + healths[i];
    };

    let mut eventHash : Field = 0;
    for i in 0..nTicks {
        eventHash = std::hash::pedersen([eventHash, selected[i], newGoalsX[i], newGoalsY[i]])[0];
    };

    [eventHash, find_max_index(points)]
}

fn setup_and_sim(
    selected : [Field; nTicks], 
    newGoalsX : [Field; nTicks], 
    newGoalsY : [Field; nTicks]
    ) -> [Field; 2] {

    // The match configuration; immutable unit traits
    let factions : [Field; nUnits] = [0; 10];
    let initialHealths : [Field; nUnits] = [200; 10];
    let ranges : [Field; nUnits] = [10; 10];
    let speeds : [Field; nUnits] = [2; 10];
    let mut initialXs : [Field; nUnits] = [0; 10];
    let initialYs : [Field; nUnits] = [0; 10];

    // Spawn entities in a line along the bottom of the map
    for i in 0..nUnits {
        initialXs[i] = i * 100;
    };

    simulate_rts(factions, initialXs, initialYs, initialHealths, ranges, speeds, selected, newGoalsX, newGoalsY)
}

fn main(selected : pub [Field; nTicks]) -> pub Field {
    // Default values to mimic player input
    let newGoalsX : [Field; nTicks] = [0; 10];
    let newGoalsY : [Field; nTicks] = [0; 10];

    // For now only return the winner
    setup_and_sim(selected, newGoalsX, newGoalsY)[1]
}
