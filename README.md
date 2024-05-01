# Inflow_PVE_correction
Matlab code for correcting inflow and partial volume effects in arterial input function (AIF) measured from DCE MRI.

# Introduction
This repository contains Matlab code to estimate the perceived pulse number (n) in blood proton and also the reconstruction of AIF with the estimated n. In this way, the inflow and partial volume effects could be simultaneously compensated. A dedicated AIF could be determined for further DCE (or DSC) analysis.

# Instructions
The Demo.m demonstrates a simple correction with an AIF signal measured in middle cerebral artery in one of our clinical datasets. This AIF signal could be replaced with any measured AIF signal, either from single arterial voxel or from a region-of-interest in an artery. 

The required parameters should be adjusted according to the acquisition protocol. 

The EstimateNofPulses.m will estimate the received pulse number of the AIF signal.

The EstimateC.m will then reconstruct the AIF with estimated number of pulse. 

# Contact
For further questions, you may refer to the paper or contact me at r04548023(at)gmail.com.
