#!/bin/bash

option=$1

if [ "$option" == "bs" ]; then
    for beam_size in {1..25}
    do
        output_file="assignments/05/beam_search/translations_beam_${beam_size}.txt"
        python translate_beam.py \
            --data data/en-fr/prepared \
            --dicts data/en-fr/prepared \
            --checkpoint-path assignments/03/baseline/checkpoints/checkpoint_best.pt \
            --output "${output_file}" \
            --batch-size 64 \
            --beam-size "${beam_size}"

        echo "Translations with beam_size ${beam_size} saved to ${output_file}"
    done

elif [ "$option" == "pp" ]; then
    for beam_size in {1..25}
    do
        translation_file="assignments/05/beam_search/translations_beam_${beam_size}.txt"
        translation_file_pp="assignments/05/beam_search/translations_beam_${beam_size}_pp.txt"

        scripts/postprocess.sh "${translation_file}" "${translation_file_pp}" en
    done

elif [ "$option" == "score" ]; then
    for beam_size in {1..25}
    do 
        translation_file_pp="assignments/05/beam_search/translations_beam_${beam_size}_pp.txt"
        translation_file_score="assignments/05/beam_search/translations_beam_${beam_size}_sb_score.txt"

        cat data/en-fr/raw/test.en | sacrebleu "${translation_file_pp}" >>  "${translation_file_score}" 
    done
elif [ "$option" == "uid" ]; then
    beam_size=5
    uid=0.5
    output_file="assignments/05/beam_search/translations_beam_${beam_size}_uid_${uid}.txt"
    translation_file_pp="assignments/05/beam_search/translations_beam_${beam_size}_uid_${uid}_pp.txt"
    translation_file_score="assignments/05/beam_search/translations_beam_${beam_size}_uid_${uid}_sb_score.txt"
    python translate_beam.py \
        --data data/en-fr/prepared \
        --dicts data/en-fr/prepared \
        --checkpoint-path assignments/03/baseline/checkpoints/checkpoint_best.pt \
        --output "${output_file}" \
        --batch-size 64 \
        --beam-size "${beam_size}" \
        --uid "${uid}"
    scripts/postprocess.sh "${output_file}" "${translation_file_pp}" en
    cat data/en-fr/raw/test.en | sacrebleu "${translation_file_pp}" >>  "${translation_file_score}" 
    echo "Translations with beam_size ${beam_size} and uuid ${uid} saved to ${output_file}"
elif [ "$option" == "diversity" ]; then
    for beam_size in 5 10 15
    do
        for gamma in 0.1 1. 1.3
        do
            top_k=3
            output_file="assignments/05/diversity/translations_beam_diversity_beam_${beam_size}_topk${top_k}_gamma_${gamma}.txt"
            python translate_beam.py \
                --data data/en-fr/prepared \
                --dicts data/en-fr/prepared \
                --checkpoint-path assignments/03/baseline/checkpoints/checkpoint_best.pt \
                --output "${output_file}" \
                --batch-size 64 \
                --beam-size "${beam_size}" \
                --gamma "${gamma}" \
                --top_k "${top_k}"
            echo "Diversity with beam_size ${beam_size} and top_k ${top_k} saved to ${output_file}"
        done
    done
else
    echo "Invalid option. Please use 'bs', 'pp', 'score', 'uid', or 'diversity'."
fi
