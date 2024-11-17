<!--
Licensed to the Apache Software Foundation (ASF) under one or more
contributor license agreements.  See the NOTICE file distributed with
this work for additional information regarding copyright ownership.
The ASF licenses this file to You under the Apache License, Version 2.0
(the "License"); you may not use this file except in compliance with
the License.  You may obtain a copy of the License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software
distributed under the License is distributed on an "AS IS" BASIS,
WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
See the License for the specific language governing permissions and
limitations under the License.
-->

Welcome to Apache OpenNLP Models!
===========

[![GitHub license](https://img.shields.io/badge/license-Apache%202-blue.svg)](https://raw.githubusercontent.com/apache/opennlp-models/main/LICENSE)
[![Maven Central](https://maven-badges.herokuapp.com/maven-central/org.apache.opennlp/opennlp-models/badge.svg)](https://maven-badges.herokuapp.com/maven-central/org.apache.opennlp/opennlp-models)
[![Build Status](https://github.com/apache/opennlp-models/workflows/Java%20CI/badge.svg)](https://github.com/apache/opennlp-models/actions)
[![Contributors](https://img.shields.io/github/contributors/apache/opennlp-models)](https://github.com/apache/opennlp-models/graphs/contributors)
[![GitHub pull requests](https://img.shields.io/github/issues-pr-raw/apache/opennlp-models.svg)](https://github.com/apache/opennlp-models/pulls)
[![Stack Overflow](https://img.shields.io/badge/stack%20overflow-opennlp-f1eefe.svg)](https://stackoverflow.com/questions/tagged/opennlp)

The Apache OpenNLP library provides binary models for processing of natural language text. 
This repository is intended for the distribution of model files as a Maven artifacts.

## Useful Links

For additional information, visit the [OpenNLP Home Page](https://opennlp.apache.org/models.html).

You can use OpenNLP with many languages. Additional demo models are provided [here](https://opennlp.sourceforge.net/models-1.5/).

The models are fully compatible with the latest [OpenNLP release](https://opennlp.apache.org/download.html). They can be used for testing or getting started.

> [!NOTE]  
> Please train your own models for all other, specialized use cases.

Documentation, including JavaDocs, code usage and command-line interface examples are available [here](https://opennlp.apache.org/docs/)

You can also follow our [mailing lists](https://opennlp.apache.org/mailing-lists.html) for news and updates.

## Overview

We provide **Tokenizer**, **Sentence Detector** and **Part-of-Speech Tagger** models for the following 23 languages:

   - Bulgarian
   - Croatian
   - Czech
   - Danish
   - Dutch
   - English
   - Estonian
   - Finnish
   - French
   - German
   - Italian
   - Latvian
   - Norwegian
   - Polish
   - Portuguese
   - Romanian
   - Russian
   - Serbian
   - Slovak
   - Slovenian
   - Spanish
   - Swedish
   - Ukrainian

These models are compatible with OpenNLP `>= 1.0.0`. Further details are available at the [OpenNLP Models](https://opennlp.apache.org/models.html) 
page and in the [CHANGELOG](https://dist.apache.org/repos/dist/release/opennlp/models/ud-models-1.1/CHANGES).

In addition, we provide a **Language Detector**, which is able to detect 103 languages in ISO 693-3 standard. 
Works well with longer texts that have at least 2 sentences or more from the same language. 

It is compatible with OpenNLP `>= 1.8.3`. Model details are available [here](https://downloads.apache.org/opennlp/models/langdetect/1.8.3/).

## Getting Started

The [Universal Dependencies](https://universaldependencies.org) (UD) community provides a framework for consistent annotation of grammar across different human languages.
The project is developing cross-linguistically consistent treebank annotation for 150+ languages.           

### Referencing published Models

You can import UD-based model artifacts directly via Maven, SBT or Gradle, for instance:

#### Maven

```
<dependency>
    <groupId>org.apache.opennlp</groupId>
    <artifactId>opennlp-models-pos-de</artifactId>
    <version>${opennlp.models.version}</version>
</dependency>
```

for all **23** supported languages, listed on the Apache OpenNLP [Model page](https://opennlp.apache.org/models.html).

The broader langdetect model can be referenced like this:   

```
<dependency>
    <groupId>org.apache.opennlp</groupId>
    <artifactId>opennlp-models-langdetect</artifactId>
    <version>${opennlp.models.version}</version>
</dependency>
```

#### SBT

```
libraryDependencies += "org.apache.opennlp" % "opennlp-models-langdetect" % "${opennlp.version}"
```

#### Gradle

```
compile group: "org.apache.opennlp", name: "opennlp-models-langdetect", version: "${opennlp.version}"
```

For more details please check our [documentation](https://opennlp.apache.org/docs/)


### Training Models

All released _sentence detection_, _tokenization_, _lemmatizer_, and _POS tagging_ models were and can be trained via the `ud-train.sh` script.
It is located in the _opennlp-models-training-ud_ directory in this repository. 

#### Preparing the environment

Before training UD-based OpenNLP models, the execution environment needs the latest [OpenNLP release](https://opennlp.apache.org/download.html) and the latest set of [UD treebanks](https://universaldependencies.org/#download).
Download the corresponding archive files and uncompress them both in the same directory in which the training script resides.
Rename both folders according to the `OPENNLP_HOME` and `UD_HOME` variables. 

> [!IMPORTANT]
> Check and adjust the version string in both variables, that is, to the versions you have actually downloaded. 

#### Selecting model types

Next, select what type of models should be trained. By default, the script defines:

```
TRAIN_TOKENIZER="true"
TRAIN_POSTAGGER="true"
TRAIN_SENTDETECT="true"
TRAIN_LEMMATIZER="true"
```

Simply switch off a certain type, by setting the corresponding variable to false.

#### Selecting languages

By default, treebanks of 23 supported languages are included in the `MODELS` variable of the script.
If only a smaller or different (sub-)set is required, this variable can simply be edited.
The format must be followed: `<Language>|<2-digit-locale-code>|<UD treebank name>`, for example: `English|en|EWT` or `Swedish|sv|Talbanken`.

> [!NOTE]
> The full list of supported languages and related treebanks is available [here](https://universaldependencies.org/#current-ud-languages).
> Yet, even listed on the UD page, training OpenNLP models might not succeed. If it succeeds, check the evaluation logs (_*.eval_) if the computed accuracy meets your expectations.
                       
#### Adjusting training parameters

Once you're done with the preparations, check the `ud-train.conf` file. With this config file, you can adjust the number of threads used for certain training steps. 
Moreover, it is possible to adjust the number of iterations (default: 150) to achieve (slightly) better model performance.

#### Executing 'ud-train.sh'

Make sure to make the `ud-train.sh` script executable. 
On Unix-oid environments this can simply be achieved by setting the execute bit: `chmod 744 ud-train.sh`.

> [!TIP]
> As model training(s) can be a long-running task, depending on CPU type and number of CPU cores,
> the script should be started inside a [`screen`](https://www.man7.org/linux/man-pages/man1/screen.1.html) instance.

Finally, execute the script via invoking `./ud-train.sh` and start brewing and enjoying some :coffee:.

The script logs each training (and evaluation) step per selected language / treebank, thus allowing progress tracking. 

#### Evaluating trained Models

After a training step succeeds, a corresponding evaluation step is executed. If you want to skip it, set `EVAL_AFTER_TRAINING` to `false`.
In case the evaluation is run, the resulting performance (accuracy) is written to files ending with `.eval`.                                                                                                                        

### Adding new Models

When adding new models to the `pom.xml`, ensure to add new models to the `expected-models.txt` file located in `opennlp-models-test`.
In addition, make sure a sha256 hash is computed on each binary artifact. 
The corresponding value must be set or updated correctly for each model type and language.                                       

## Contributing

The Apache OpenNLP project is developed by volunteers and is always looking for new contributors to work on all parts of the project. Every contribution is welcome and needed to make it better. A contribution can be anything from a small documentation typo fix to a new component.

If you would like to get involved please follow the instructions [here](https://github.com/apache/opennlp/blob/main/.github/CONTRIBUTING.md)
