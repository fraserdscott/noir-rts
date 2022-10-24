const N: Field = 4;

fn main(
    from0 : Field, 
    from1 : Field,
    from2 : Field,
    from3 : Field,
    to0 : Field, 
    to1 : Field,
    to2 : Field,
    to3 : Field,
    value0 : Field, 
    value1 : Field,
    value2 : Field,
    value3 : Field,
) {
    let froms = [from0, from1, from2, from3];
    let tos = [to0, to1, to2, to3];
    let values = [value0, value1, value2, value3];
    
    let mut balances = [0, 0, 0, 0];

    for i in 0..N {
        for j in 0..N {
            if (froms[i] == 0) & (tos[i] == tos[j]) {
                balances[j] = balances[j] + values[i];
            }
        }
    };

    constrain balances[0] == 4;
    constrain balances[1] == 2;
    constrain balances[2] == 4;
    constrain balances[3] == 4;
}