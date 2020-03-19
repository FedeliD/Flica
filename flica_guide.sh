#!/usr/bin/env bash
#Pipeline for FLICA analyses


#Requirements: FSL, FreeSurfer and Matlab
#Download FLICA tar.gz files
#Sort your data per modality (e.g. VBM, Thickness, Gyrification, and Fractal Dimension)
#recon all with: recon-all -subject $s -i $f -3T -parallel -openmp 4 -nthreads 4 -all
#all subjects are PCS-VBM-00x.nii inside of a PCS-VBM-00x directory




##in matlab
addpath '/usr/local/freesurfer/matlab/'
addpath '/usr/local/fsl/etc/matlab/'


#in bash
#concatenate in 4D files your data

#for VBM
fslmerge -a GMV_4D smwp1*.nii

#for surface files
#!/usr/bin/env bash
#thickness extraction

echo "extracting thickness"

export SUBJECTS_DIR=/media/duzzo/TOSHIBA_EXT/VBM_FLICA/flica_analyses/jon
#makesure fsaverage is in $SUBJECTS_DIR
for i in PCS*; do
  cd $SUBJECTS_DIR
  echo "================================"
  echo "processing rh of subj $i"
  echo "================================"
  mris_preproc --s $i --target fsaverage --hemi rh --meas thickness --out rh.$i.thickness.00.mgh
  mri_surf2surf --hemi rh --s fsaverage --sval rh.$i.thickness.00.mgh --fwhm 15  --tval rh.$i.thickness.15B.mgh
done
  mri_concat rh.*.thickness.15B.mgh --o merged_thickness_rh.mgh

for i in PCS*; do
    cd $SUBJECTS_DIR
    echo "================================"
    echo "processing lh of subj $i"
    echo "================================"
    mris_preproc --s $i --target fsaverage --hemi lh --meas thickness --out lh.$i.thickness.00.mgh
    mri_surf2surf --hemi lh --s fsaverage --sval lh.$i.thickness.00.mgh --fwhm 15  --tval lh.$i.thickness.15B.mgh
  done
    mri_concat lh.*.thickness.15B.mgh --o merged_thickness_lh.mgh

###########################################################################
export SUBJECTS_DIR=/media/duzzo/TOSHIBA_EXT/VBM_FLICA/flica_analyses/jon
echo "extracting surface area"

for i in PCS*; do
  cd $SUBJECTS_DIR
  echo "================================"
  echo "processing rh of subj $i"
  echo "================================"
  mris_preproc --s $i --target fsaverage --hemi rh --meas area --out rh.$i.area.00.mgh
  mri_surf2surf --hemi rh --s fsaverage --sval rh.$i.area.00.mgh --fwhm 20  --tval rh.$i.area.20B.mgh
done
  mri_concat rh.*.area.20B.mgh --o merged_area_rh.mgh

for i in PCS*; do
    cd $SUBJECTS_DIR
    echo "================================"
    echo "processing lh of subj $i"
    echo "================================"
    mris_preproc --s $i --target fsaverage --hemi lh --meas area --out lh.$i.area.00.mgh
    mri_surf2surf --hemi lh --s fsaverage --sval lh.$i.area.00.mgh --fwhm 20  --tval lh.$i.area.20B.mgh
  done
    mri_concat lh.*.area.20B.mgh --o merged_area_lh.mgh



###########################################################################
export SUBJECTS_DIR=/media/duzzo/TOSHIBA_EXT/VBM_FLICA/flica_analyses/jon
echo "extracting curvature"
for i in PCS*; do
  cd $SUBJECTS_DIR
  echo "================================"
  echo "processing rh of subj $i"
  echo "================================"
  mris_preproc --s $i --target fsaverage --hemi rh --meas curv --out rh.$i.curv.00.mgh
  mri_surf2surf --hemi rh --s fsaverage --sval rh.$i.curv.00.mgh --fwhm 20  --tval rh.$i.curv.20B.mgh
done
  mri_concat rh.*.curv.20B.mgh --o merged_curv_rh.mgh

for i in PCS*; do
    cd $SUBJECTS_DIR
    echo "================================"
    echo "processing lh of subj $i"
    echo "================================"
    mris_preproc --s $i --target fsaverage --hemi lh --meas curv --out lh.$i.curv.00.mgh
    mri_surf2surf --hemi lh --s fsaverage --sval lh.$i.curv.00.mgh --fwhm 20  --tval lh.$i.curv.20B.mgh
  done
    mri_concat lh.*.curv.20B.mgh --o merged_curv_lh.mgh



###########################################################################
export SUBJECTS_DIR=/media/duzzo/TOSHIBA_EXT/VBM_FLICA/flica_analyses/jon
echo "extracting mean absolute curvature (Gyrification)"
for i in rh.PCS-VBM-*.curv.00.mgh; do
 cd $SUBJECTS_DIR
 echo "================================"
 echo "processing rh of subj $i"
 echo "================================"
 y=${i%.curv.00.mgh}
 echo $i
 mri_concat --i $i --abs --o $y.abscurv.00.mgh
 echo $y
 z=$y.abscurv.00.mgh
 echo $z
 mri_surf2surf --hemi rh --s fsaverage --sval $z --fwhm 20  --tval $y.abscurv.20B.mgh
done
  mri_concat rh.*abscurv.20B.mgh --o merged_abscurv_rh.mgh

for i in lh.PCS-VBM-*.curv.00.mgh; do
 cd $SUBJECTS_DIR
 echo "================================"
 echo "processing lh of subj $i"
 echo "================================"
 y=${i%.curv.00.mgh}
 echo $i
 mri_concat --i $i --abs --o $y.abscurv.00.mgh
 echo $y
 z=$y.abscurv.00.mgh
 echo $z
 mri_surf2surf --hemi lh --s fsaverage --sval $z --fwhm 20  --tval $y.abscurv.20B.mgh
done
  mri_concat lh.*abscurv.20B.mgh --o merged_abscurv_lh.mgh

#makes a beep sound when finished
( speaker-test -t sine -f 1000 )& pid=$! ; sleep 0.2s ; kill -9 $pid


=======================================================================================================

#in Matlab specify all your measures
gmv = '/media/duzzo/TOSHIBA_EXT/VBM_FLICA/flica_analyses/GM_mod_merg.nii.gz'
thick = '/media/duzzo/TOSHIBA_EXT/VBM_FLICA/flica_analyses/?h.thick.fsaverage.mgh'
area = '/media/duzzo/TOSHIBA_EXT/VBM_FLICA/flica_analyses/?h.area.fsaverage.mgh'
gyr = '/media/duzzo/TOSHIBA_EXT/VBM_FLICA/flica_analyses/?h.abscurv.fsaverage.mgh'

outdir = '/media/duzzo/TOSHIBA_EXT/VBM_FLICA/flica_analyses/outdir'

#in Matlab load your files
#first  edit line #127 in flica_load.m to
#missingSubjects = all(isnan(Y{k}) | (Y{k}==0));

Yfiles = {gmv, thick, gyr, area};
[Y,fileinfo] = flica_load(Yfiles);

#In Matlab set up the options and run the analysis
#makesure that num_components < nsubjects; it should be something like nsubj/4
clear opts
opts.num_components = 20;
opts.maxits = 500; #10000

#Run flica_parseoptions to see a list of options and default values (and get annoying message: "Yes I realize this isn't enough detail, but it's a start. Please refer to source code.")


#change save_vest into save_vest_pretty in the FLICA_save_everything .m file
Morig = flica(Y, opts)
[M,weights] = flica_reorder(Morig);
#M = flica_reorder(Morig)
flica_save_everything(outdir, M, fileinfo)
#des.Age = load('age.txt');
#des.Group = load('group.txt');
#change line 32 of fgetl ==> fgets becomes fopen

#NOTE for rendering, you have to resample niftiOut_mi1.nii.gz into MNI152 space
#simply fslsplit onto the original image, use spm to set origin to 000 and apply matrix to all images, resample first vol to MNI152_T1_2mm_brain.nii.gz and apply same matrix to all the others
