# Use the official Miniconda3 base image
FROM continuumio/miniconda3:4.10.3

# Set the working directory
WORKDIR /esr

# Install Python 3.8.8
RUN conda install -y python=3.8.8

# Create a new Conda environment named "myenv"
RUN conda create -n myenv python=3.8.8

# Activate the environment and install packages
RUN echo "source activate myenv" > ~/.bashrc
ENV PATH /opt/conda/envs/myenv/bin:$PATH

# Install the required packages in the new environment
RUN conda install -n myenv -c pytorch -c conda-forge \
    pytorch \
    transformers=4.6.1 \
    nltk=3.6.2

# Install java
RUN conda install -n myenv -c conda-forge openjdk=11.0.8

# Install wordnet
RUN python -c"import nltk; nltk.download('wordnet'); nltk.download('stopwords'); nltk.download('punkt')"

# Install curl and gdown for downloading dataset and model checkpoints
RUN apt-get -y update; apt-get -y install curl unzip
RUN conda install -n myenv -c conda-forge gdown
