 (cd "$(git rev-parse --show-toplevel)" && git apply --3way <<'EOF' 
diff --git a/README.md b/README.md
index 6397d0cbc1deb3a59c214bd972fac9aafc8c0c69..f5b8f0376808acc83cb859810d4c5e247d8e5209 100644
--- a/README.md
+++ b/README.md
@@ -1 +1,47 @@
-# HEE_3D
\ No newline at end of file
+# HEE_3D
+
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
+
+## Getting started
+
+1. Open Mathematica and set the working directory to the repository root:
+
+   ```wolfram
+   SetDirectory["/path/to/HEE_3D"];  (* Adjust to your local clone path *)
+   << model.m
+   ```
+
+2. Prepare an input latent tensor `lzt`. You can either:
+   - Use `findlzt` with a target function `func` that characterises your system, or
+   - Provide your own tensor matching the expected shape `{101, 1}`.
+
+3. Run the generator:
+
+   ```wolfram
+   generatedTensor = geogen[lzt];
+   ```
+
+4. Inspect or export the resulting tensor using Mathematica's standard visualisation and data export tools (for example, `ListPointPlot3D`, `ListSliceDensityPlot`, `Export`).
+
+## Troubleshooting
+
+- **ONNX import errors** – Ensure that the ONNXRuntimeLink paclet is installed and that your Mathematica version supports ONNX import. Run `Needs["ONNXRuntimeLink`"]` to verify.
+- **Shape mismatches** – Verify that the input tensor fed into `geogen` has dimensions `{101, 1, 1}` (Mathematica will automatically coerce vector inputs to this shape when using `findlzt`).
+- **Performance considerations** – Running 101 ONNX models sequentially can be compute intensive. Consider enabling GPU support via ONNXRuntimeLink on compatible hardware.
+
+## Citation
+
+If you use HEE_3D in academic or industrial work, please cite the repository and any associated publications describing the underlying method.
 
EOF
)
