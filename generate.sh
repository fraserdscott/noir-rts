zeros=($(seq 0 1 9))
 
printf -v zerosStr '%s,' "${zeros[@]}"

echo "" > Prover.toml
echo "selected=[${zerosStr%,}]" >> Prover.toml
echo "newGoalsX=[${zerosStr%,}]" >> Prover.toml
echo "newGoalsY=[${zerosStr%,}]" >> Prover.toml
echo "return=0" >> Prover.toml