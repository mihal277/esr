#!/bin/bash

set -e

data_folder="data"
fews_filename="fews.zip"
wsd_eval_framework_filename="WSD_Evaluation_Framework.zip"
ufsac_filename="ufsac-public-2.1.tar.xz"
models_filename="esr_experiment__with_models__mirror.zip"

# download datasets if don't exits
curl https://nlp.cs.washington.edu/fews/$fews_filename --output $fews_filename -C -
curl http://lcl.uniroma1.it/wsdeval/data/$wsd_eval_framework_filename --output $wsd_eval_framework_filename -C -
if [ ! -f $ufsac_filename ]; then
  echo $ufsac_filename
  gdown https://drive.google.com/file/d/1kwBMIDBTf6heRno9bdLvF-DahSLHIZyV -O $ufsac_filename
fi

#download model weights if don't exist
if [ ! -f $models_filename ]; then
  gdown https://drive.google.com/file/d/1FCARKVbhWzEBJgFD7PSmYAZQwhH6b3BU -O $models_filename
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




