+HEE_3D provides a Mathematica-based workflow that chains a bank of ONNX models to iteratively build a three-dimensional tensor. The repository includes the pre-trained models together with helper Mathematica utilities for running the inference pipeline end-to-end.
+
+## Repository structure
+
+- `onnx/` – 101 sequential ONNX models (`model_1.onnx` … `model_101.onnx`). Each model consumes the output of the previous stage, allowing the pipeline to progressively refine the generated tensor.
+- `model.m` – Mathematica package that imports the ONNX models and exposes two helper functions:
+  - `geogen[lzt_]` runs the 101-stage inference loop and returns the generated tensor.
+  - `findlzt[func_]` estimates the latent input tensor (`lzt`) by solving a root-finding problem and reshaping the result for consumption by the network chain.
+- `example.nb` – Wolfram Notebook illustrating how to work with the package (open in Mathematica).
+
+## Prerequisites
+
+- Wolfram Mathematica 12.1 or newer (for ONNX model import and neural network execution).
+- The [ONNXRuntimeLink](https://resources.wolframcloud.com/PacletRepository/resources/WolframResearch/ONNXRuntimeLink/) paclet is recommended for accelerated inference, although Mathematica's built-in ONNX import also works for CPU evaluation.

