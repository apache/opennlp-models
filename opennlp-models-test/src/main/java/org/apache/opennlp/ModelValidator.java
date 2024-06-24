/*
 * Licensed to the Apache Software Foundation (ASF) under one or more
 * contributor license agreements.  See the NOTICE file distributed with
 * this work for additional information regarding copyright ownership.
 * The ASF licenses this file to you under the Apache License, Version 2.0
 * (the "License"); you may not use this file except in compliance with
 * the License.  You may obtain a copy of the License at
 *
 *      http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 */
package org.apache.opennlp;

import java.io.BufferedReader;
import java.io.IOException;
import java.io.InputStream;
import java.io.InputStreamReader;
import java.nio.file.Files;
import java.nio.file.Path;
import java.util.List;
import java.util.jar.JarFile;
import java.util.regex.Pattern;
import java.util.stream.Stream;

/**
 * Simple validator run via Maven to check the produced JAR files for validity.
 */
public class ModelValidator {

  public static void main(String[] args) {
    if (args.length != 1) {
      throw new IllegalArgumentException("This tool expects at least one argument");
    }
    System.err.println("Executing basic model validation checks.");

    final Path testBaseDir = Path.of(args[0]);
    final Path projectDir = testBaseDir.getParent();
    final List<String> expectedModels = getExpectedModels();

    final String pattern = "opennlp-models.*\\.jar";

    final List<Path> availableModelJars = getAvailableModelJars(pattern, testBaseDir, projectDir);

    if (expectedModels.size() != availableModelJars.size()) {
      throw new IllegalArgumentException("Detected a mismatch between " +
          "expected and available models! " +
          "Expected: " + expectedModels.size() +
          "; Actual: " + availableModelJars.size());
    }

    for (String model : expectedModels) {
      boolean found;
      for (Path availableJar : availableModelJars) {
        found = isModelInJar(availableJar, model);
        if (found) {
          return;
        }
      }
      throw new IllegalArgumentException(
          "Expected model '" + model + "' could not be found inside the generated JAR files!");
    }


  }

  public static boolean isModelInJar(Path jarFilePath, String expectedModel) {
    try (JarFile jarFile = new JarFile(jarFilePath.toFile())) {
      return jarFile.stream()
          .anyMatch(entry -> entry.getName().equals(expectedModel));
    } catch (IOException e) {
      throw new RuntimeException("Failed to read the JAR file: " + jarFilePath, e);
    }
  }

  private static List<Path> getAvailableModelJars(String pattern, Path testDir, Path projectDir) {
    final Pattern regexPattern = Pattern.compile(pattern);
    try (Stream<Path> stream = Files.walk(projectDir)) {
      return stream
          .filter(Files::isRegularFile)
          .filter(path -> !path.startsWith(testDir))
          .filter(path -> regexPattern.matcher(path.getFileName().toString()).matches())
          .toList();
    } catch (IOException e) {
      throw new RuntimeException(e);
    }
  }

  private static List<String> getExpectedModels() {
    try (InputStream inputStream = Thread.currentThread().getContextClassLoader().getResourceAsStream("expected-models.txt")) {
      if (inputStream == null) {
        throw new IllegalArgumentException("Expected model file could not be found!");
      }

      try (BufferedReader reader = new BufferedReader(new InputStreamReader(inputStream))) {
        return reader.lines()
            .filter(line -> !line.startsWith("#") && !line.trim().isEmpty())
            .toList();
      }
    } catch (IOException e) {
      throw new RuntimeException(e);
    }
  }
}
