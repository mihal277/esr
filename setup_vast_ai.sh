set -e

# Install base utilities
apt-get update && apt-get install -y git wget

# Install miniconda
export CONDA_DIR="/opt/conda"
wget --quiet https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh -O ~/miniconda.sh && \
  /bin/bash ~/miniconda.sh -b -p /opt/conda

# Put conda in path so we can use conda activate
export PATH="$CONDA_DIR/bin:$PATH"

# setup venv
conda install -y python=3.8.8
conda create -n myenv python=3.8.8
echo "source activate myenv" > ~/.bashrc
export PATH="/opt/conda/envs/myenv/bin:$PATH"

# Install the required packages in the new environment
conda install -y -n myenv -c pytorch -c conda-forge \
  pytorch \
  transformers=4.6.1 \
  nltk=3.6.2

# Install java
conda install -y -n myenv -c conda-forge openjdk=11.0.8

# Install wordnet
python -c"import nltk; nltk.download('wordnet'); nltk.download('stopwords'); nltk.download('punkt')"

# Install curl and gdown for downloading dataset and model checkpoints
apt-get -y update; apt-get -y install curl unzip
conda install -n myenv -c conda-forge gdown


## download data

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





