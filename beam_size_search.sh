#!/bin/bash

for beam_size in {1..25}
do
    output_file="assignments/05/ex01/translations_beam_${beam_size}.txt"
    
    python translate_beam.py \
        --data data/en-fr/prepared \
        --dicts data/en-fr/prepared \
        --checkpoint-path assignments/03/baseline/checkpoints/checkpoint_best.pt \
        --output "${output_file}" \
        --batch-size 64 --beam-size "${beam_size}"

    echo "Translations with beam_size ${beam_size} saved to ${output_file}"
done


