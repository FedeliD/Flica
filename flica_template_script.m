%% Demo script to run your own date through FLICA.

%% Set up:
setenv('FSLDIR','/usr/local/fsl')
addpath([getenv('FSLDIR') '/etc/matlab/'])
addpath '/mnt/226AE1226AE0F407/Neurosoftware/flica_2013-01-15/flica'
addpath '/media/duzzo/TOSHIBA EXT/VBM_FLICA/JoN_dataset'

%% Load data
Yfiles = {'/media/duzzo/TOSHIBA EXT/VBM_FLICA/JoN_dataset/GMV_4D.nii.gz', '/media/duzzo/TOSHIBA EXT/VBM_FLICA/JoN_dataset/thick_4D.mgh', '/media/duzzo/TOSHIBA EXT/VBM_FLICA/JoN_dataset/gyr_4D.mgh', '/media/duzzo/TOSHIBA EXT/VBM_FLICA/JoN_dataset/thick_4D.mgh'};
% NOTE that these should be downsampled to around 20k voxels in the mask,
% per modality... hoping to increase this memory/cpu-related limitation.
[Y,fileinfo] = flica_load(Yfiles);
fileinfo.shortNames = {'GMV', 'Thickness', 'Gyrification', 'Surface'};

%% Run FLICA
clear opts
opts.num_components = 16;
opts.maxits = 500;

Morig = flica(Y, opts);
[M, weights] = flica_reorder(Morig);

%% Save results
outdir = '/tmp/flicaOUTPUT/';
flica_save_everything(outdir, M, fileinfo);

%% Produce correlation plots
design = load('design.txt');
clear des
des.ev1 = design(:,1);
flica_posthoc_correlations(outdir, des);

%% Produce the report using command-line scripts:
cd(outdir)
dos('render_surfaces.sh');
dos('surfaces_to_volumes_all.sh fsaverage5 /usr/local/fsl/data/standard/MNI152_T1_2mm.nii.gz');
dos('render_lightboxes_all.sh');
dos('flica_report.sh')
dos('open index.html')
