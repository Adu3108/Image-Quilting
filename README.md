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

## Texture Transfer

Texture Transfer problem involves rendering an object with a texture taken from a different object. In the given example, we transfer the rice texture (source texture) onto a human face (target image) to get the following output :-

<p>
  <img width="27%" src="/results/Input/texture13.png">
  <img width="5%">
  <img width="27%" src="/results/Target/srk.jpeg"> 
  <img width="5%">
  <img width="27%" src="/results/Transfer/transfer_output_2.png"> <br> <br>
  <img width="5%"> (a) Source Texture <img width="15%"> (b) Target Image <img width="19%"> (c) Output Image
</p>
