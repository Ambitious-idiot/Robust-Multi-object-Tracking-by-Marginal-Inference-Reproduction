#!/bin/bash
root=$(echo "$(cd "$(dirname "$0")"; pwd)""/../../dataset/MOT20/outputs/MOT20_test_public_dla34")
for dir in $(ls $root)
do
    for filename in $(ls "$root""/""$dir")
    do
        rm "$root""/""$dir""/""$filename"
    done
done
cd "$(echo "$(cd "$(dirname "$0")"; pwd)")"/../src
python track.py mot --val_mot20 True --load_model fairmot_dla34.pth --marginal_pr True
