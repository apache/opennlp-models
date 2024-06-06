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

[![GitHub license](https://img.shields.io/badge/license-Apache%202-blue.svg)](https://raw.githubusercontent.com/apache/opennlp/main/LICENSE)
[![Twitter Follow](https://img.shields.io/twitter/follow/ApacheOpennlp.svg?style=social)](https://twitter.com/ApacheOpenNLP)

The Apache OpenNLP library provides binary models for processing of natural language text. 
This repository is intended for the distribution of model files as a Maven artifacts.

## Useful Links

For additional information, visit the [OpenNLP Home Page](http://opennlp.apache.org/)

You can use OpenNLP with any language, further demo models are provided [here](http://opennlp.sourceforge.net/models-1.5/).

The models are fully compatible with the latest release, they can be used for testing or getting started.

Please train your own models for all other use cases.

Documentation, including JavaDocs, code usage and command-line interface examples are available [here](http://opennlp.apache.org/docs/)

You can also follow our [mailing lists](http://opennlp.apache.org/mailing-lists.html) for news and updates.

## Overview

| Component         | Language              | Compatibility | Description                                                                                                                              | README and Reports                                                                                                                                                                                                                                                                                                                                                          |
|-------------------|-----------------------| ------------- |------------------------------------------------------------------------------------------------------------------------------------------| --------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| Language Detector | Detects 103 languages | >= 1.8.3      | Detects 103 languages in ISO 693-3 standard. Works well with longer texts that have at least 2 sentences or more from the same language. | [README](https://www.apache.org/dist/opennlp/models/langdetect/1.8.3/README.txt) [Effectiveness](https://www.apache.org/dist/opennlp/models/langdetect/1.8.3/langdetect-183.bin.report.txt) [Misclassified](https://www.apache.org/dyn/closer.cgi/opennlp/models/langdetect/1.8.3/langdetect-183.bin.misclassified.txt)                                                   |
| Sentence          | fr                    | >= 1.0.0      | Sentence detection model for French                                                                                                      | [README](https://www.apache.org/dyn/closer.cgi/opennlp/models/ud-models-1.0/README) [Evaluation Logs](https://dist.apache.org/repos/dist/release/opennlp/models/ud-models-1.0/opennlp-training-eval-logs-1.0-1.9.3.zip)                                                                                                                                                    |
| Sentence          | de                    | >= 1.0.0      | Sentence detection model for German                                                                                                      | [README](https://www.apache.org/dyn/closer.cgi/opennlp/models/ud-models-1.0/README) [Evaluation Logs](https://dist.apache.org/repos/dist/release/opennlp/models/ud-models-1.0/opennlp-training-eval-logs-1.0-1.9.3.zip)                                                                                                                                                    |
| Sentence          | en                    | >= 1.0.0      | Sentence detection model for English                                                                                                     | [README](https://www.apache.org/dyn/closer.cgi/opennlp/models/ud-models-1.0/README) [Evaluation Logs](https://dist.apache.org/repos/dist/release/opennlp/models/ud-models-1.0/opennlp-training-eval-logs-1.0-1.9.3.zip)                                                                                                                                                    |
| Sentence          | it                    | >= 1.0.0      | Sentence detection model for Italian                                                                                                     | [README](https://www.apache.org/dyn/closer.cgi/opennlp/models/ud-models-1.0/README) [Evaluation Logs](https://dist.apache.org/repos/dist/release/opennlp/models/ud-models-1.0/opennlp-training-eval-logs-1.0-1.9.3.zip)                                                                                                                                                    |
| Sentence          | nl                    | >= 1.0.0      | Sentence detection model for Dutch                                                                                                       | [README](https://www.apache.org/dyn/closer.cgi/opennlp/models/ud-models-1.0/README) [Evaluation Logs](https://dist.apache.org/repos/dist/release/opennlp/models/ud-models-1.0/opennlp-training-eval-logs-1.0-1.9.3.zip)                                                                                                                                                    |
| Parts of Speech   | de                    | >= 1.0.0      | Parts of speech model for German                                                                                                         | [README](https://www.apache.org/dyn/closer.cgi/opennlp/models/ud-models-1.0/README) [Evaluation Logs](https://dist.apache.org/repos/dist/release/opennlp/models/ud-models-1.0/opennlp-training-eval-logs-1.0-1.9.3.zip)                                                                                                                                                    |
| Parts of Speech   | en                    | >= 1.0.0      | Parts of speech model for English                                                                                                        | [README](https://www.apache.org/dyn/closer.cgi/opennlp/models/ud-models-1.0/README) [Evaluation Logs](https://dist.apache.org/repos/dist/release/opennlp/models/ud-models-1.0/opennlp-training-eval-logs-1.0-1.9.3.zip)                                                                                                                                                    |
| Parts of Speech   | fr                    | >= 1.0.0      | Parts of speech model for French                                                                                                         | [README](https://www.apache.org/dyn/closer.cgi/opennlp/models/ud-models-1.0/README) [Evaluation Logs](https://dist.apache.org/repos/dist/release/opennlp/models/ud-models-1.0/opennlp-training-eval-logs-1.0-1.9.3.zip)                                                                                                                                                    |
| Parts of Speech   | it                    | >= 1.0.0      | Parts of speech model for Italian                                                                                                        | [README](https://www.apache.org/dyn/closer.cgi/opennlp/models/ud-models-1.0/README) [Evaluation Logs](https://dist.apache.org/repos/dist/release/opennlp/models/ud-models-1.0/opennlp-training-eval-logs-1.0-1.9.3.zip)                                                                                                                                                    |
| Parts of Speech   | nl                    | >= 1.0.0      | Parts of speech model for Dutch                                                                                                          | [README](https://www.apache.org/dyn/closer.cgi/opennlp/models/ud-models-1.0/README) [Evaluation Logs](https://dist.apache.org/repos/dist/release/opennlp/models/ud-models-1.0/opennlp-training-eval-logs-1.0-1.9.3.zip)                                                                                                                                                    |
| Parts of Speech   | it                    | >= 1.0.0      | Parts of speech model for Italian                                                                                                        | [README](https://www.apache.org/dyn/closer.cgi/opennlp/models/ud-models-1.0/README) [Evaluation Logs](https://dist.apache.org/repos/dist/release/opennlp/models/ud-models-1.0/opennlp-training-eval-logs-1.0-1.9.3.zip)                                                                                                                                                    |
| Tokens            | de                    | >= 1.0.0      | Tokenizer model for German                                                                                                               | [README](https://www.apache.org/dyn/closer.cgi/opennlp/models/ud-models-1.0/README) [Evaluation Logs](https://dist.apache.org/repos/dist/release/opennlp/models/ud-models-1.0/opennlp-training-eval-logs-1.0-1.9.3.zip)                                                                                                                                                    |
| Tokens            | en                    | >= 1.0.0      | Tokenizer model for English                                                                                                              | [README](https://www.apache.org/dyn/closer.cgi/opennlp/models/ud-models-1.0/README) [Evaluation Logs](https://dist.apache.org/repos/dist/release/opennlp/models/ud-models-1.0/opennlp-training-eval-logs-1.0-1.9.3.zip)                                                                                                                                                    |
| Tokens            | fr                    | >= 1.0.0      | Tokenizer model for French                                                                                                               | [README](https://www.apache.org/dyn/closer.cgi/opennlp/models/ud-models-1.0/README) [Evaluation Logs](https://dist.apache.org/repos/dist/release/opennlp/models/ud-models-1.0/opennlp-training-eval-logs-1.0-1.9.3.zip)                                                                                                                                                    |
| Tokens            | it                    | >= 1.0.0      | Tokenizer model for Italien                                                                                                              | [README](https://www.apache.org/dyn/closer.cgi/opennlp/models/ud-models-1.0/README) [Evaluation Logs](https://dist.apache.org/repos/dist/release/opennlp/models/ud-models-1.0/opennlp-training-eval-logs-1.0-1.9.3.zip)                                                                                                                                                    |
| Tokens            | nl                    | >= 1.0.0      | Tokenizer model for Dutch                                                                                                                | [README](https://www.apache.org/dyn/closer.cgi/opennlp/models/ud-models-1.0/README) [Evaluation Logs](https://dist.apache.org/repos/dist/release/opennlp/models/ud-models-1.0/opennlp-training-eval-logs-1.0-1.9.3.zip)                                                                                                                                                    |


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

For more details please check our [documentation](http://opennlp.apache.org/docs/)

## Adding a new Model

Ensure to add a new model to the `expected-models.txt` file located in `opennlp-models-test`.

## Contributing

The Apache OpenNLP project is developed by volunteers and is always looking for new contributors to work on all parts of the project. Every contribution is welcome and needed to make it better. A contribution can be anything from a small documentation typo fix to a new component.

If you would like to get involved please follow the instructions [here](https://github.com/apache/opennlp/blob/main/.github/CONTRIBUTING.md)
