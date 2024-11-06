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

You can import a model artifact directly via Maven, SBT or Gradle, for instance:

#### Maven

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

## Adding a new Model

Ensure to add a new model to the `expected-models.txt` file located in `opennlp-models-test`.

## Contributing

The Apache OpenNLP project is developed by volunteers and is always looking for new contributors to work on all parts of the project. Every contribution is welcome and needed to make it better. A contribution can be anything from a small documentation typo fix to a new component.

If you would like to get involved please follow the instructions [here](https://github.com/apache/opennlp/blob/main/.github/CONTRIBUTING.md)
