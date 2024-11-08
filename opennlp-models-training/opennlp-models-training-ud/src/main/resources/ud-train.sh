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

# Script configuration
UD_HOME="./"
OPENNLP_VERSION="opennlp-2.4.0"
OPENNLP_VERSION_NUMERIC="2.4.0"
OPENNLP_MODEL_VERSION="1.1"
OPENNLP_HOME="./apache-opennlp-2.4.0"
OUTPUT_MODELS="./ud-models-2.4.0"
GPG_PUBLIC_KEY="" # the public key from the OPENNLP KEYS file in short form.
EVAL_AFTER_TRAINING="true"
CREATE_RELEASE="true"
ENCODING="UTF-8"


# Model(s) to train
declare -a MODELS=("English|en|EWT" "Dutch|nl|Alpino" "French|fr|GSD" "German|de|GSD" "Italian|it|VIT" "Bulgarian|bg|BTB" "Czech|cs|PDT" "Croatian|hr|SET" "Danish|da|DDT" "Estonian|et|EDT" "Finnish|fi|TDT" "Latvian|lv|LVTB" "Norwegian|no|Bokmaal" "Polish|pl|PDB" "Portuguese|pt|GSD" "Romanian|ro|RRT" "Russian|ru|GSD" "Serbian|sr|SET" "Slovenian|sl|SSJ" "Spanish|es|GSD" "Slovak|sk|SNK" "Swedish|sv|Talbanken" "Ukrainian|uk|IU")

# Create output directory
mkdir -p ${OUTPUT_MODELS}

for i in "${MODELS[@]}"
do

  echo $i
  LANG=`echo $i | cut -d'|' -f1`
  LANGCODE=`echo $i | cut -d'|' -f2`
  SUBSET=`echo $i | cut -d'|' -f3`
  SUBSETLC=`echo ${SUBSET} | tr '[:upper:]' '[:lower:]'`

  # Tokenizer model
  echo -e "\nTraining tokenizer model ${SUBSET} ${LANG}..."
  ${OPENNLP_HOME}/bin/opennlp TokenizerTrainer.conllu -model ${OUTPUT_MODELS}/opennlp-${LANGCODE}-ud-${SUBSETLC}-tokens-${OPENNLP_MODEL_VERSION}-${OPENNLP_VERSION_NUMERIC}.bin -lang ${LANGCODE} -data ./ud-treebanks-v2.14/UD_${LANG}-${SUBSET}/${LANGCODE}_${SUBSETLC}-ud-train.conllu -encoding ${ENCODING} > ${OUTPUT_MODELS}/opennlp-${LANGCODE}-ud-${SUBSETLC}-tokens-${OPENNLP_MODEL_VERSION}-${OPENNLP_VERSION_NUMERIC}.train

  if [ ${EVAL_AFTER_TRAINING} == "true" ]; then
    echo -e "\nEvaluating tokenizer model ${SUBSET} ${LANG}..."
    ${OPENNLP_HOME}/bin/opennlp TokenizerMEEvaluator.conllu -model ${OUTPUT_MODELS}/opennlp-${LANGCODE}-ud-${SUBSETLC}-tokens-${OPENNLP_MODEL_VERSION}-${OPENNLP_VERSION_NUMERIC}.bin -data ./ud-treebanks-v2.14/UD_${LANG}-${SUBSET}/${LANGCODE}_${SUBSETLC}-ud-test.conllu -encoding ${ENCODING} > ${OUTPUT_MODELS}/opennlp-${LANGCODE}-ud-${SUBSETLC}-tokens-${OPENNLP_MODEL_VERSION}-${OPENNLP_VERSION_NUMERIC}.eval
  fi

  if [ ${CREATE_RELEASE} == "true" ]; then
    echo -e "\nCreating hashes and ASC signature for tokenizer model ${SUBSET} ${LANG}..."
    sha512sum ${OUTPUT_MODELS}/opennlp-${LANGCODE}-ud-${SUBSETLC}-tokens-${OPENNLP_MODEL_VERSION}-${OPENNLP_VERSION_NUMERIC}.bin > ${OUTPUT_MODELS}/opennlp-${LANGCODE}-ud-${SUBSETLC}-tokens-${OPENNLP_MODEL_VERSION}-${OPENNLP_VERSION_NUMERIC}.bin.sha512
    sha256sum ${OUTPUT_MODELS}/opennlp-${LANGCODE}-ud-${SUBSETLC}-tokens-${OPENNLP_MODEL_VERSION}-${OPENNLP_VERSION_NUMERIC}.bin > ${OUTPUT_MODELS}/opennlp-${LANGCODE}-ud-${SUBSETLC}-tokens-${OPENNLP_MODEL_VERSION}-${OPENNLP_VERSION_NUMERIC}.bin.sha256
    gpg --default-key $GPG_PUBLIC_KEY --armor --output ${OUTPUT_MODELS}/opennlp-${LANGCODE}-ud-${SUBSETLC}-tokens-${OPENNLP_MODEL_VERSION}-${OPENNLP_VERSION_NUMERIC}.bin.asc --detach-sign ${OUTPUT_MODELS}/opennlp-${LANGCODE}-ud-${SUBSETLC}-tokens-${OPENNLP_MODEL_VERSION}-${OPENNLP_VERSION_NUMERIC}.bin
  fi
  
  # Sentence model
  echo -e "\nTraining sentence model ${SUBSET} ${LANG}..."
  ${OPENNLP_HOME}/bin/opennlp SentenceDetectorTrainer.conllu -model ${OUTPUT_MODELS}/opennlp-${LANGCODE}-ud-${SUBSETLC}-sentence-${OPENNLP_MODEL_VERSION}-${OPENNLP_VERSION_NUMERIC}.bin -lang ${LANGCODE} -data ./ud-treebanks-v2.14/UD_${LANG}-${SUBSET}/${LANGCODE}_${SUBSETLC}-ud-train.conllu -encoding ${ENCODING} -sentencesPerSample 10 > ${OUTPUT_MODELS}/opennlp-${LANGCODE}-ud-${SUBSETLC}-sentence-${OPENNLP_MODEL_VERSION}-${OPENNLP_VERSION_NUMERIC}.train

  if [ ${EVAL_AFTER_TRAINING} == "true" ]; then
    echo -e "Evaluating sentence model ${SUBSET} ${LANG}..."
    ${OPENNLP_HOME}/bin/opennlp SentenceDetectorEvaluator.conllu -model ${OUTPUT_MODELS}/opennlp-${LANGCODE}-ud-${SUBSETLC}-sentence-${OPENNLP_MODEL_VERSION}-${OPENNLP_VERSION_NUMERIC}.bin -data ./ud-treebanks-v2.14/UD_${LANG}-${SUBSET}/${LANGCODE}_${SUBSETLC}-ud-test.conllu -encoding ${ENCODING} -sentencesPerSample 10 > ${OUTPUT_MODELS}/opennlp-${LANGCODE}-ud-${SUBSETLC}-sentence-${OPENNLP_MODEL_VERSION}-${OPENNLP_VERSION_NUMERIC}.eval
  fi

  if [ ${CREATE_RELEASE} == "true" ]; then
    echo -e "\nCreating hashes and ASC signature for sentence model ${SUBSET} ${LANG}..."
    sha512sum ${OUTPUT_MODELS}/opennlp-${LANGCODE}-ud-${SUBSETLC}-sentence-${OPENNLP_MODEL_VERSION}-${OPENNLP_VERSION_NUMERIC}.bin > ${OUTPUT_MODELS}/opennlp-${LANGCODE}-ud-${SUBSETLC}-sentence-${OPENNLP_MODEL_VERSION}-${OPENNLP_VERSION_NUMERIC}.bin.sha512
    sha256sum ${OUTPUT_MODELS}/opennlp-${LANGCODE}-ud-${SUBSETLC}-sentence-${OPENNLP_MODEL_VERSION}-${OPENNLP_VERSION_NUMERIC}.bin > ${OUTPUT_MODELS}/opennlp-${LANGCODE}-ud-${SUBSETLC}-sentence-${OPENNLP_MODEL_VERSION}-${OPENNLP_VERSION_NUMERIC}.bin.sha256
    gpg --default-key $GPG_PUBLIC_KEY --armor --output ${OUTPUT_MODELS}/opennlp-${LANGCODE}-ud-${SUBSETLC}-sentence-${OPENNLP_MODEL_VERSION}-${OPENNLP_VERSION_NUMERIC}.bin.asc --detach-sign ${OUTPUT_MODELS}/opennlp-${LANGCODE}-ud-${SUBSETLC}-sentence-${OPENNLP_MODEL_VERSION}-${OPENNLP_VERSION_NUMERIC}.bin
  fi

  # POS model
  echo -e "\nTraining POS model ${SUBSET} ${LANG}..."
  ${OPENNLP_HOME}/bin/opennlp POSTaggerTrainer.conllu -model ${OUTPUT_MODELS}/opennlp-${LANGCODE}-ud-${SUBSETLC}-pos-${OPENNLP_MODEL_VERSION}-${OPENNLP_VERSION_NUMERIC}.bin -data ./ud-treebanks-v2.14/UD_${LANG}-${SUBSET}/${LANGCODE}_${SUBSETLC}-ud-train.conllu -encoding ${ENCODING} -lang ${LANGCODE} > ${OUTPUT_MODELS}/opennlp-${LANGCODE}-ud-${SUBSETLC}-pos-${OPENNLP_MODEL_VERSION}-${OPENNLP_VERSION_NUMERIC}.eval > ${OUTPUT_MODELS}/opennlp-${LANGCODE}-ud-${SUBSETLC}-pos-${OPENNLP_MODEL_VERSION}-${OPENNLP_VERSION_NUMERIC}.train

  if [ ${EVAL_AFTER_TRAINING} == "true" ]; then
    echo -e "\nEvaluating POS model ${SUBSET} ${LANG}..."
    ${OPENNLP_HOME}/bin/opennlp POSTaggerEvaluator.conllu -model ${OUTPUT_MODELS}/opennlp-${LANGCODE}-ud-${SUBSETLC}-pos-${OPENNLP_MODEL_VERSION}-${OPENNLP_VERSION_NUMERIC}.bin -data ./ud-treebanks-v2.14/UD_${LANG}-${SUBSET}/${LANGCODE}_${SUBSETLC}-ud-test.conllu -encoding ${ENCODING} > ${OUTPUT_MODELS}/opennlp-${LANGCODE}-ud-${SUBSETLC}-pos-${OPENNLP_MODEL_VERSION}-${OPENNLP_VERSION_NUMERIC}.eval
  fi

  if [ ${CREATE_RELEASE} == "true" ]; then
    echo -e "\nCreating hashes and ASC signature for POS model ${SUBSET} ${LANG}..."
    sha512sum ${OUTPUT_MODELS}/opennlp-${LANGCODE}-ud-${SUBSETLC}-pos-${OPENNLP_MODEL_VERSION}-${OPENNLP_VERSION_NUMERIC}.bin > ${OUTPUT_MODELS}/opennlp-${LANGCODE}-ud-${SUBSETLC}-pos-${OPENNLP_MODEL_VERSION}-${OPENNLP_VERSION_NUMERIC}.bin.sha512
    sha256sum ${OUTPUT_MODELS}/opennlp-${LANGCODE}-ud-${SUBSETLC}-pos-${OPENNLP_MODEL_VERSION}-${OPENNLP_VERSION_NUMERIC}.bin > ${OUTPUT_MODELS}/opennlp-${LANGCODE}-ud-${SUBSETLC}-pos-${OPENNLP_MODEL_VERSION}-${OPENNLP_VERSION_NUMERIC}.bin.sha256
    gpg --default-key $GPG_PUBLIC_KEY --armor --output ${OUTPUT_MODELS}/opennlp-${LANGCODE}-ud-${SUBSETLC}-pos-${OPENNLP_MODEL_VERSION}-${OPENNLP_VERSION_NUMERIC}.bin.asc --detach-sign ${OUTPUT_MODELS}/opennlp-${LANGCODE}-ud-${SUBSETLC}-pos-${OPENNLP_MODEL_VERSION}-${OPENNLP_VERSION_NUMERIC}.bin
  fi

done

if [ ${CREATE_RELEASE} == "true" ]; then
    cd ${OUTPUT_MODELS};
    echo -e "\nCreate ZIP with eval and train logs."
    zip opennlp-training-eval-logs-${OPENNLP_MODEL_VERSION}-${OPENNLP_VERSION_NUMERIC}.zip *train *.eval
    sha512sum opennlp-training-eval-logs-${OPENNLP_MODEL_VERSION}-${OPENNLP_VERSION_NUMERIC}.zip > opennlp-training-eval-logs-${OPENNLP_MODEL_VERSION}-${OPENNLP_VERSION_NUMERIC}.zip.sha512
    sha256sum opennlp-training-eval-logs-${OPENNLP_MODEL_VERSION}-${OPENNLP_VERSION_NUMERIC}.zip > opennlp-training-eval-logs-${OPENNLP_MODEL_VERSION}-${OPENNLP_VERSION_NUMERIC}.zip.sha256
    gpg --default-key $GPG_PUBLIC_KEY --armor --output opennlp-training-eval-logs-${OPENNLP_MODEL_VERSION}-${OPENNLP_VERSION_NUMERIC}.zip.asc --detach-sign opennlp-training-eval-logs-${OPENNLP_MODEL_VERSION}-${OPENNLP_VERSION_NUMERIC}.zip

    echo -e "\nRemove the path from sha512 and sha256 checksum files"
    # Remove the path from sha512 and sha256 checksum files
    sed -i "" "s|${OUTPUT_MODELS}/||" *.sha512
    sed -i "" "s|${OUTPUT_MODELS}/||" *.sha256

fi