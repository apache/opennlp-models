#!/bin/bash

# Licensed to the Apache Software Foundation (ASF) under one
# or more contributor license agreements.  See the NOTICE file
# distributed with this work for additional information
# regarding copyright ownership.  The ASF licenses this file
# to you under the Apache License, Version 2.0 (the
# "License"); you may not use this file except in compliance
# with the License.  You may obtain a copy of the License at
#
#   http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing,
# software distributed under the License is distributed on an
# "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY
# KIND, either express or implied.  See the License for the
# specific language governing permissions and limitations
# under the License.

set -e

# This script facilitates training OpenNLP models on Universal Dependencies (UD) data.

#################################################
# Essential ud-train script configuration       #
# - directories and file locations              #
# - versioning                                  #
#################################################
TRAIN_HOME="./"
ENCODING="UTF-8"
# The file to configure the number of compute threads and training iterations
OPENNLP_CONFIG="ud-train.conf"
# The directory a stable OpenNLP release is located in
OPENNLP_HOME="./apache-opennlp-2.5.0"
# The target version for training opennlp-models
OPENNLP_MODEL_VERSION="1.2"
# The version of OpenNLP tools to use for training
OPENNLP_VERSION_NUMERIC="2.5.0"
# The directory the resulting binary models are written to
OUTPUT_MODELS="./ud-models-2.5.0"
# The directory the ud treebanks are located in
UD_HOME="./ud-treebanks-v2.15"

#################################################
# Parameters for training, evaluation & release #
#################################################
# Defines which models to train. If 'true', training of that model type is conducted
TRAIN_TOKENIZER="true"
TRAIN_POSTAGGER="true"
TRAIN_SENTDETECT="true"
TRAIN_LEMMATIZER="true"
# If 'true', each resulting model is evaluated, 'false' otherwise
EVAL_AFTER_TRAINING="true"
# If 'true, training of experimental languages will be attempted, otherwise only stable languages & treebanks are used
EXPERIMENTAL_LANGUAGES="false"
# If 'true', all release preparation steps are conducted, 'false' otherwise
CREATE_RELEASE="false"
# The public key from the OPENNLP KEYS file in short form
GPG_PUBLIC_KEY=""

# Model(s) to train
declare -a MODELS=("English|en|EWT" "Dutch|nl|Alpino" "French|fr|GSD" "German|de|GSD" "Italian|it|VIT" "Bulgarian|bg|BTB" "Czech|cs|PDT" "Croatian|hr|SET" "Danish|da|DDT" "Estonian|et|EDT" "Finnish|fi|TDT" "Latvian|lv|LVTB" "Norwegian|no|Bokmaal" "Polish|pl|PDB" "Portuguese|pt|GSD" "Romanian|ro|RRT" "Russian|ru|GSD" "Serbian|sr|SET" "Slovenian|sl|SSJ" "Spanish|es|GSD" "Slovak|sk|SNK" "Swedish|sv|Talbanken" "Ukrainian|uk|IU")

# Create output directory
mkdir -p ${OUTPUT_MODELS}

for i in "${MODELS[@]}"
do
  echo -e "\n"
  echo $i
  LANG=`echo $i | cut -d'|' -f1`
  LANGCODE=`echo $i | cut -d'|' -f2`
  SUBSET=`echo $i | cut -d'|' -f3`
  SUBSETLC=`echo ${SUBSET} | tr '[:upper:]' '[:lower:]'`

  # Tokenizer model
  if [ ${TRAIN_TOKENIZER} == "true" ]; then
    echo -e "Training tokenizer model ${SUBSET} ${LANG}..."
    ${OPENNLP_HOME}/bin/opennlp TokenizerTrainer.conllu -params ${TRAIN_HOME}/${OPENNLP_CONFIG} -model ${OUTPUT_MODELS}/opennlp-${LANGCODE}-ud-${SUBSETLC}-tokens-${OPENNLP_MODEL_VERSION}-${OPENNLP_VERSION_NUMERIC}.bin -lang ${LANGCODE} -data ${UD_HOME}/UD_${LANG}-${SUBSET}/${LANGCODE}_${SUBSETLC}-ud-train.conllu -encoding ${ENCODING} > ${OUTPUT_MODELS}/opennlp-${LANGCODE}-ud-${SUBSETLC}-tokens-${OPENNLP_MODEL_VERSION}-${OPENNLP_VERSION_NUMERIC}.train

    if [ ${EVAL_AFTER_TRAINING} == "true" ]; then
      echo -e "Evaluating tokenizer model ${SUBSET} ${LANG}..."
      ${OPENNLP_HOME}/bin/opennlp TokenizerMEEvaluator.conllu -model ${OUTPUT_MODELS}/opennlp-${LANGCODE}-ud-${SUBSETLC}-tokens-${OPENNLP_MODEL_VERSION}-${OPENNLP_VERSION_NUMERIC}.bin -data ${UD_HOME}/UD_${LANG}-${SUBSET}/${LANGCODE}_${SUBSETLC}-ud-test.conllu -encoding ${ENCODING} > ${OUTPUT_MODELS}/opennlp-${LANGCODE}-ud-${SUBSETLC}-tokens-${OPENNLP_MODEL_VERSION}-${OPENNLP_VERSION_NUMERIC}.eval
    fi
    if [ ${CREATE_RELEASE} == "true" ]; then
      echo -e "Creating hashes and ASC signature for tokenizer model ${SUBSET} ${LANG}..."
      sha512sum ${OUTPUT_MODELS}/opennlp-${LANGCODE}-ud-${SUBSETLC}-tokens-${OPENNLP_MODEL_VERSION}-${OPENNLP_VERSION_NUMERIC}.bin > ${OUTPUT_MODELS}/opennlp-${LANGCODE}-ud-${SUBSETLC}-tokens-${OPENNLP_MODEL_VERSION}-${OPENNLP_VERSION_NUMERIC}.bin.sha512
      sha256sum ${OUTPUT_MODELS}/opennlp-${LANGCODE}-ud-${SUBSETLC}-tokens-${OPENNLP_MODEL_VERSION}-${OPENNLP_VERSION_NUMERIC}.bin > ${OUTPUT_MODELS}/opennlp-${LANGCODE}-ud-${SUBSETLC}-tokens-${OPENNLP_MODEL_VERSION}-${OPENNLP_VERSION_NUMERIC}.bin.sha256
      gpg --default-key $GPG_PUBLIC_KEY --armor --output ${OUTPUT_MODELS}/opennlp-${LANGCODE}-ud-${SUBSETLC}-tokens-${OPENNLP_MODEL_VERSION}-${OPENNLP_VERSION_NUMERIC}.bin.asc --detach-sign ${OUTPUT_MODELS}/opennlp-${LANGCODE}-ud-${SUBSETLC}-tokens-${OPENNLP_MODEL_VERSION}-${OPENNLP_VERSION_NUMERIC}.bin
    fi
  fi

  # Sentence model
  if [ ${TRAIN_SENTDETECT} == "true" ]; then
    echo -e "Training sentence model ${SUBSET} ${LANG}..."
    ${OPENNLP_HOME}/bin/opennlp SentenceDetectorTrainer.conllu -params ${TRAIN_HOME}/${OPENNLP_CONFIG} -model ${OUTPUT_MODELS}/opennlp-${LANGCODE}-ud-${SUBSETLC}-sentence-${OPENNLP_MODEL_VERSION}-${OPENNLP_VERSION_NUMERIC}.bin -lang ${LANGCODE} -data ${UD_HOME}/UD_${LANG}-${SUBSET}/${LANGCODE}_${SUBSETLC}-ud-train.conllu -encoding ${ENCODING} -sentencesPerSample 10 > ${OUTPUT_MODELS}/opennlp-${LANGCODE}-ud-${SUBSETLC}-sentence-${OPENNLP_MODEL_VERSION}-${OPENNLP_VERSION_NUMERIC}.train

    if [ ${EVAL_AFTER_TRAINING} == "true" ]; then
      echo -e "Evaluating sentence model ${SUBSET} ${LANG}..."
      ${OPENNLP_HOME}/bin/opennlp SentenceDetectorEvaluator.conllu -model ${OUTPUT_MODELS}/opennlp-${LANGCODE}-ud-${SUBSETLC}-sentence-${OPENNLP_MODEL_VERSION}-${OPENNLP_VERSION_NUMERIC}.bin -data ${UD_HOME}/UD_${LANG}-${SUBSET}/${LANGCODE}_${SUBSETLC}-ud-test.conllu -encoding ${ENCODING} -sentencesPerSample 10 > ${OUTPUT_MODELS}/opennlp-${LANGCODE}-ud-${SUBSETLC}-sentence-${OPENNLP_MODEL_VERSION}-${OPENNLP_VERSION_NUMERIC}.eval
    fi

    if [ ${CREATE_RELEASE} == "true" ]; then
      echo -e "Creating hashes and ASC signature for sentence model ${SUBSET} ${LANG}..."
      sha512sum ${OUTPUT_MODELS}/opennlp-${LANGCODE}-ud-${SUBSETLC}-sentence-${OPENNLP_MODEL_VERSION}-${OPENNLP_VERSION_NUMERIC}.bin > ${OUTPUT_MODELS}/opennlp-${LANGCODE}-ud-${SUBSETLC}-sentence-${OPENNLP_MODEL_VERSION}-${OPENNLP_VERSION_NUMERIC}.bin.sha512
      sha256sum ${OUTPUT_MODELS}/opennlp-${LANGCODE}-ud-${SUBSETLC}-sentence-${OPENNLP_MODEL_VERSION}-${OPENNLP_VERSION_NUMERIC}.bin > ${OUTPUT_MODELS}/opennlp-${LANGCODE}-ud-${SUBSETLC}-sentence-${OPENNLP_MODEL_VERSION}-${OPENNLP_VERSION_NUMERIC}.bin.sha256
      gpg --default-key $GPG_PUBLIC_KEY --armor --output ${OUTPUT_MODELS}/opennlp-${LANGCODE}-ud-${SUBSETLC}-sentence-${OPENNLP_MODEL_VERSION}-${OPENNLP_VERSION_NUMERIC}.bin.asc --detach-sign ${OUTPUT_MODELS}/opennlp-${LANGCODE}-ud-${SUBSETLC}-sentence-${OPENNLP_MODEL_VERSION}-${OPENNLP_VERSION_NUMERIC}.bin
    fi
  fi

  # POS model
  if [ ${TRAIN_POSTAGGER} == "true" ]; then
    echo -e "Training POS model ${SUBSET} ${LANG}..."
    ${OPENNLP_HOME}/bin/opennlp POSTaggerTrainer.conllu -params ${TRAIN_HOME}/${OPENNLP_CONFIG} -model ${OUTPUT_MODELS}/opennlp-${LANGCODE}-ud-${SUBSETLC}-pos-${OPENNLP_MODEL_VERSION}-${OPENNLP_VERSION_NUMERIC}.bin -data ${UD_HOME}/UD_${LANG}-${SUBSET}/${LANGCODE}_${SUBSETLC}-ud-train.conllu -encoding ${ENCODING} -lang ${LANGCODE} > ${OUTPUT_MODELS}/opennlp-${LANGCODE}-ud-${SUBSETLC}-pos-${OPENNLP_MODEL_VERSION}-${OPENNLP_VERSION_NUMERIC}.train

    if [ ${EVAL_AFTER_TRAINING} == "true" ]; then
      echo -e "Evaluating POS model ${SUBSET} ${LANG}..."
      ${OPENNLP_HOME}/bin/opennlp POSTaggerEvaluator.conllu -model ${OUTPUT_MODELS}/opennlp-${LANGCODE}-ud-${SUBSETLC}-pos-${OPENNLP_MODEL_VERSION}-${OPENNLP_VERSION_NUMERIC}.bin -data ${UD_HOME}/UD_${LANG}-${SUBSET}/${LANGCODE}_${SUBSETLC}-ud-test.conllu -encoding ${ENCODING} > ${OUTPUT_MODELS}/opennlp-${LANGCODE}-ud-${SUBSETLC}-pos-${OPENNLP_MODEL_VERSION}-${OPENNLP_VERSION_NUMERIC}.eval
    fi

    if [ ${CREATE_RELEASE} == "true" ]; then
      echo -e "Creating hashes and ASC signature for POS model ${SUBSET} ${LANG}..."
      sha512sum ${OUTPUT_MODELS}/opennlp-${LANGCODE}-ud-${SUBSETLC}-pos-${OPENNLP_MODEL_VERSION}-${OPENNLP_VERSION_NUMERIC}.bin > ${OUTPUT_MODELS}/opennlp-${LANGCODE}-ud-${SUBSETLC}-pos-${OPENNLP_MODEL_VERSION}-${OPENNLP_VERSION_NUMERIC}.bin.sha512
      sha256sum ${OUTPUT_MODELS}/opennlp-${LANGCODE}-ud-${SUBSETLC}-pos-${OPENNLP_MODEL_VERSION}-${OPENNLP_VERSION_NUMERIC}.bin > ${OUTPUT_MODELS}/opennlp-${LANGCODE}-ud-${SUBSETLC}-pos-${OPENNLP_MODEL_VERSION}-${OPENNLP_VERSION_NUMERIC}.bin.sha256
      gpg --default-key $GPG_PUBLIC_KEY --armor --output ${OUTPUT_MODELS}/opennlp-${LANGCODE}-ud-${SUBSETLC}-pos-${OPENNLP_MODEL_VERSION}-${OPENNLP_VERSION_NUMERIC}.bin.asc --detach-sign ${OUTPUT_MODELS}/opennlp-${LANGCODE}-ud-${SUBSETLC}-pos-${OPENNLP_MODEL_VERSION}-${OPENNLP_VERSION_NUMERIC}.bin
    fi
  fi

  # Lemmatizer model
  if [ ${TRAIN_LEMMATIZER} == "true" ]; then
    echo -e "Training Lemmatizer model ${SUBSET} ${LANG}..."
    ${OPENNLP_HOME}/bin/opennlp LemmatizerTrainerME.conllu -params ${TRAIN_HOME}/${OPENNLP_CONFIG} -model ${OUTPUT_MODELS}/opennlp-${LANGCODE}-ud-${SUBSETLC}-lemmas-${OPENNLP_MODEL_VERSION}-${OPENNLP_VERSION_NUMERIC}.bin -data ${UD_HOME}/UD_${LANG}-${SUBSET}/${LANGCODE}_${SUBSETLC}-ud-train.conllu -encoding ${ENCODING} -lang ${LANGCODE} > ${OUTPUT_MODELS}/opennlp-${LANGCODE}-ud-${SUBSETLC}-lemmas-${OPENNLP_MODEL_VERSION}-${OPENNLP_VERSION_NUMERIC}.train

    if [ ${EVAL_AFTER_TRAINING} == "true" ]; then
      echo -e "Evaluating Lemmatizer model ${SUBSET} ${LANG}..."
      ${OPENNLP_HOME}/bin/opennlp LemmatizerEvaluator.conllu -model ${OUTPUT_MODELS}/opennlp-${LANGCODE}-ud-${SUBSETLC}-lemmas-${OPENNLP_MODEL_VERSION}-${OPENNLP_VERSION_NUMERIC}.bin -data ${UD_HOME}/UD_${LANG}-${SUBSET}/${LANGCODE}_${SUBSETLC}-ud-test.conllu -encoding ${ENCODING} > ${OUTPUT_MODELS}/opennlp-${LANGCODE}-ud-${SUBSETLC}-lemmas-${OPENNLP_MODEL_VERSION}-${OPENNLP_VERSION_NUMERIC}.eval
    fi

    if [ ${CREATE_RELEASE} == "true" ]; then
      echo -e "Creating hashes and ASC signature for Lemmatizer model ${SUBSET} ${LANG}..."
      sha512sum ${OUTPUT_MODELS}/opennlp-${LANGCODE}-ud-${SUBSETLC}-lemmas-${OPENNLP_MODEL_VERSION}-${OPENNLP_VERSION_NUMERIC}.bin > ${OUTPUT_MODELS}/opennlp-${LANGCODE}-ud-${SUBSETLC}-lemmas-${OPENNLP_MODEL_VERSION}-${OPENNLP_VERSION_NUMERIC}.bin.sha512
      sha256sum ${OUTPUT_MODELS}/opennlp-${LANGCODE}-ud-${SUBSETLC}-lemmas-${OPENNLP_MODEL_VERSION}-${OPENNLP_VERSION_NUMERIC}.bin > ${OUTPUT_MODELS}/opennlp-${LANGCODE}-ud-${SUBSETLC}-lemmas-${OPENNLP_MODEL_VERSION}-${OPENNLP_VERSION_NUMERIC}.bin.sha256
      gpg --default-key $GPG_KEY --armor --output ${OUTPUT_MODELS}/opennlp-${LANGCODE}-ud-${SUBSETLC}-lemmas-${OPENNLP_MODEL_VERSION}-${OPENNLP_VERSION_NUMERIC}.bin.asc --detach-sign ${OUTPUT_MODELS}/opennlp-${LANGCODE}-ud-${SUBSETLC}-lemmas-${OPENNLP_MODEL_VERSION}-${OPENNLP_VERSION_NUMERIC}.bin
    fi
  fi

done

# Conducts finalization steps to collect all training (and evaluation) log files into a zip
if [ ${CREATE_RELEASE} == "true" ]; then
    cd ${OUTPUT_MODELS};
    echo -e "\nCreating ZIP with eval and training logs..."
    zip opennlp-training-eval-logs-${OPENNLP_MODEL_VERSION}-${OPENNLP_VERSION_NUMERIC}.zip *train *.eval
    sha512sum opennlp-training-eval-logs-${OPENNLP_MODEL_VERSION}-${OPENNLP_VERSION_NUMERIC}.zip > opennlp-training-eval-logs-${OPENNLP_MODEL_VERSION}-${OPENNLP_VERSION_NUMERIC}.zip.sha512
    sha256sum opennlp-training-eval-logs-${OPENNLP_MODEL_VERSION}-${OPENNLP_VERSION_NUMERIC}.zip > opennlp-training-eval-logs-${OPENNLP_MODEL_VERSION}-${OPENNLP_VERSION_NUMERIC}.zip.sha256
    gpg --default-key $GPG_PUBLIC_KEY --armor --output opennlp-training-eval-logs-${OPENNLP_MODEL_VERSION}-${OPENNLP_VERSION_NUMERIC}.zip.asc --detach-sign opennlp-training-eval-logs-${OPENNLP_MODEL_VERSION}-${OPENNLP_VERSION_NUMERIC}.zip

    echo -e "\nRemove the path from sha512 and sha256 checksum files"
    # Remove the path from sha512 and sha256 checksum files
    sed -i "" "s|${OUTPUT_MODELS}/||" *.sha512
    sed -i "" "s|${OUTPUT_MODELS}/||" *.sha256

fi