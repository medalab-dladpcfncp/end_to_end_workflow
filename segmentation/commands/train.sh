#!/bin/bash

export CUDA_VISIBLE_DEVICES="0,1,2,3"

python -m manafaln.apps.train -c config/config_train.json
