#!/bin/bash

set -e

data_folder="data"
fews_filename="fews.zip"
wsd_eval_framework_filename="WSD_Evaluation_Framework.zip"
ufsac_filename="ufsac-public-2.1.tar.xz"
models_filename="esr_experiment__with_models__mirror.zip"

pip install gdown
apt install unzip

# download datasets if don't exits
if [ ! -f $ufsac_filename ]; then
  echo $ufsac_filename
  gdown 1kwBMIDBTf6heRno9bdLvF-DahSLHIZyV -O $ufsac_filename
fi

#download model weights if don't exist
if [ ! -f $models_filename ]; then
  gdown 1FCARKVbhWzEBJgFD7PSmYAZQwhH6b3BU -O $models_filename
fi

#download fews if doesn't exist
if [ ! -f $fews_filename ]; then
  gdown 10ruqtxvUr-RWYQKjLsqewB4e10ohF2ig -O $fews_filename
fi

#download wsd eval framework if doesn't exist
if [ ! -f $wsd_eval_framework_filename ]; then
  gdown 1oPv63rAyr_SSFTyrw3RcOlgII7TDUWvw -O $wsd_eval_framework_filename
fi


# unpack datasets
mkdir -p data

unzip -n $fews_filename -d $data_folder
unzip -n $wsd_eval_framework_filename -d $data_folder
tar --skip-old-files -xvf $ufsac_filename -C $data_folder

# unpack models
if [ $(find experiment -name "pytorch_model.bin" | wc -l) -lt 6 ]; then
  unzip -n $models_filename && mv experiment experiment__old && mv esr_experiment__mirror/experiment experiment
fi




