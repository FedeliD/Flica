#!/usr/bin/env bash
#Pipeline for FLICA analyses


#Requirements: FSL, FreeSurfer and Matlab
#Download FLICA tar.gz files
#Sort your data per modality (e.g. VBM, Thickness, Gyrification, and Fractal Dimension)


##in matlab
addpath '../usr/local/freesurfer/matlab/'
addpath '../usr/local/fsl/etc/matlab/'


#in bash
#concatenate in 4D files your data

#for VBM
fslmerge -a GMV_4D smwp1*.nii

#for surface files

for f in *.gii; do
  filename=$(basename -- "$f")
  extension="${filename##*.}"
  filename="${filename%.*}"
  mris_convert $f $filename.mgh

done

#change "gyr" with your measure name
mri_concat s*.mgh --o gyr_4D.mgh


#in Matlab
