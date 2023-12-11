#!/bin/bash

option=$1

folder="assignments/05/uid/"

if [ "$option" == "bs" ]; then
    for beam_size in 5 10 15
    do
        for uid_value in 0.1 0.3 0.5 0.7
        do
            output_file="${folder}translations_beam_${beam_size}_uid_${uid_value}.txt"
            python translate_beam.py \
                --data data/en-fr/prepared \
                --dicts data/en-fr/prepared \
                --checkpoint-path assignments/03/baseline/checkpoints/checkpoint_best.pt \
                --output "${output_file}" \
                --batch-size 64 --uid "${uid_value}" --beam-size "${beam_size}"

            echo "Translations with beam_size ${beam_size} and uid ${uid_value} saved to ${output_file}"
        done
    done

elif [ "$option" == "pp" ]; then
    for beam_size in 5 10 15
    do
        for uid_value in 0.1 0.3 0.5 0.7
        do
            translation_file="${folder}translations_beam_${beam_size}_uid_${uid_value}.txt"
            translation_file_pp="${folder}translations_beam_${beam_size}_uid_${uid_value}_pp.txt"

            scripts/postprocess.sh "${translation_file}" "${translation_file_pp}" en
        done
    done

elif [ "$option" == "score" ]; then
    for beam_size in 5 10 15
    do
        for uid_value in 0.1 0.3 0.5 0.7
        do
            translation_file_pp="${folder}translations_beam_${beam_size}_uid_${uid_value}_pp.txt"
            translation_file_score="${folder}translations_beam_${beam_size}_uid_${uid_value}_sb_score.txt"

            cat data/en-fr/raw/test.en | sacrebleu "${translation_file_pp}" >>  "${translation_file_score}"
        done
    done

else
    echo "Invalid option. Please use 'bs', 'pp', or 'score'."
fi
