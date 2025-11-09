# HEE_3D

HEE_3D is a Mathematica project that chains a bank of ONNX models to iteratively build a three-dimensional tensor from an input latent vector. The repository ships the full set of pre-trained models together with the Wolfram Language utilities required to orchestrate the inference loop.

## Repository structure

| Path | Description |
| --- | --- |
| `onnx/model_*.onnx` | Sequential ONNX checkpoints (`model_1.onnx` … `model_101.onnx`). Each stage refines the tensor produced by the previous model. |
| `model.m` | Mathematica package that loads the ONNX models and exposes the helper functions documented below. |
| `example.nb` | Wolfram Notebook with a minimal walkthrough for interactive exploration. |

## Requirements

- Wolfram Mathematica 12.1 or newer.
- [ONNXRuntimeLink](https://resources.wolframcloud.com/PacletRepository/resources/WolframResearch/ONNXRuntimeLink/) paclet for accelerated execution (Mathematica's built-in ONNX runtime also works on CPU).
- ~1.3 GB of free disk space for the collection of ONNX checkpoints.

## Installation

1. Clone the repository and ensure the `onnx/` directory containing `model_1.onnx` … `model_101.onnx` remains adjacent to `model.m`.
2. Launch Mathematica and set the working directory to the project root:

   ```wolfram
   SetDirectory["/path/to/HEE_3D"]; (* Update with your local path *)
   << model.m
   ```

3. Load the ONNXRuntimeLink paclet if you plan to offload execution to GPU:

   ```wolfram
   Needs["ONNXRuntimeLink`"];
   ONNXRuntimeLoadLibrary["GPU"]; (* optional; defaults to CPU if omitted *)
   ```

## Usage

The `model.m` package defines two public helpers:

- `geogen[lzt_]` — consumes a latent tensor `lzt` and runs it through the 101-stage ONNX chain, returning the accumulated tensor `tgt`.
- `findlzt[func_]` — numerically estimates an appropriate latent tensor by solving a root-finding problem based on a user-supplied function `func`.

A minimal session looks like:

```wolfram
(* Load the package as shown in the installation section *)
latent = findlzt[targetFunction];
result = geogen[latent];
Dimensions[result]
```

The helper returns a tensor of shape `{101, 1, 1}`. Mathematica's standard visualisation tools (for example, `ListPointPlot3D`, `ListSliceDensityPlot`, `ListDensityPlot3D`) work well for exploring the output.

### Notebook walkthrough

Open `example.nb` in Mathematica to follow a guided, cell-by-cell execution of the same workflow. The notebook preloads `model.m`, prepares a latent tensor, and demonstrates exporting intermediate tensors for further analysis.

## Troubleshooting

- **ONNX import errors** — Confirm that your Mathematica version can import ONNX models. Installing the ONNXRuntimeLink paclet resolves most compatibility issues.
- **Dimension mismatches** — `geogen` expects `lzt` with dimensions `{101, 1}`. The helper reshapes it internally, but providing tensors in other shapes may trigger pattern-match errors.
- **Performance** — Running 101 ONNX models sequentially is compute-intensive. Consider enabling GPU support through ONNXRuntimeLink or batching experiments to amortise the load time of the checkpoints.

## Citation

If you use HEE_3D in academic or industrial research, please cite the repository and any related publications that describe the method.
