# Image Quilting

This repository contains the project done as a part of CS663: Fundamentals of Digital Image Processing at IIT Bombay in Autumn 2022. 

## Problem Statement

In this project, we aim to implement the [paper](https://people.eecs.berkeley.edu/~efros/research/quilting/quilting.pdf) which proposes a fast and simple algorithm for texture synthesis and then extends that algorithm to perform texture transfer.

## Texture Synthesis

Texture synthesis problem involves taking a sample of texture and generate an unlimited amount of image data which, while not exactly like the original, will be perceived by humans to be the same texture. An example for this problem could be as follows :-

<p>
  <img width="40%" src="/results/Input/texture13.png">
  <img width="10%">
  <img width="40%" src="/results/Quilting/3/output13.png"> <br> <br>
  <img width="12%"> (a) Input Image <img width="38%"> (b) Output Image
</p>

---

The paper presents 3 patch-based strategies for this task. First, we define $S_B$ to be the set of all overlapping patches of user-defined size in the input texture image.

### 1. Random Placement of Blocks

The larger texture is obtained by simply tiling with blocks taken randomly from $S_B$

### 2. Constrained Overlapping Placement of Blocks

The larger texture is obtained by searching $S_B$ for such a block that by some measure agrees with its neighbors along the region of overlap.

### 3. Minimum Error Boundary Cut

In this strategy, we allow blocks to have ragged edges. For this, we make a cut between two overlapping blocks on the pixels where the two textures match best (that is, where the overlap error is low). This can be easily implemented using Dynamic Programming. For more details, refer to the paper in the `references` folder.

<img width="678" alt="Screenshot 2024-06-09 at 5 10 09 PM" src="https://github.com/Adu3108/Image-Quilting/assets/81511060/e45bb46b-7eaa-416e-9b8e-ac4da23bd6b0">

---

All 3 strategies have been implemented in MATLAB and can be found in the `code/quilting` folder.

```
.
├── get_patches.m
├── strategy_1.m
├── strategy_2.m
└── strategy_3.m
```

## Texture Transfer

Texture Transfer problem involves rendering an object with a texture taken from a different object. In the given example, we transfer rice texture (source texture) onto a human face (target image) to get the following output :-

<p>
  <img width="27%" src="/results/Input/texture13.png">
  <img width="5%">
  <img width="27%" src="/results/Target/srk.jpeg"> 
  <img width="5%">
  <img width="27%" src="/results/Transfer/transfer_output_2.png"> <br> <br>
  <img width="5%"> (a) Source Texture <img width="15%"> (b) Target Image <img width="19%"> (c) Output Image
</p>

---

In order to perform texture transfer, we augment the the synthesis algorithm by requiring that each patch satisfy a desired correspondence map, as well as satisfy the texture synthesis requirements. For more details, refer to the paper.

The texture transfer algorithm has been implemented in MATLAB and can be found at `code/transfer/main.m`
