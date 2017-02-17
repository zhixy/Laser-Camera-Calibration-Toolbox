% Intrinsic and Extrinsic Camera Parameters
%
% This script file can be directly excecuted under Matlab to recover the camera intrinsic and extrinsic parameters.
% IMPORTANT: This file contains neither the structure of the calibration objects nor the image coordinates of the calibration points.
%            All those complementary variables are saved in the complete matlab data file Calib_Results.mat.
% For more information regarding the calibration model visit http://www.vision.caltech.edu/bouguetj/calib_doc/


%-- Focal length:
fc = [ 1588.853342543796771 ; 1589.141065148706048 ];

%-- Principal point:
cc = [ 336.852104684709388 ; 166.220483494858200 ];

%-- Skew coefficient:
alpha_c = 0.000000000000000;

%-- Distortion coefficients:
kc = [ -0.183448717338282 ; -0.034396151458065 ; -0.005473481906443 ; 0.004392952805618 ; 0.000000000000000 ];

%-- Focal length uncertainty:
fc_error = [ 31.801580904116800 ; 29.314132245923947 ];

%-- Principal point uncertainty:
cc_error = [ 49.273756028476519 ; 39.985395373378047 ];

%-- Skew coefficient uncertainty:
alpha_c_error = 0.000000000000000;

%-- Distortion coefficients uncertainty:
kc_error = [ 0.066741056034172 ; 0.873747062658826 ; 0.006527073109278 ; 0.004504614774849 ; 0.000000000000000 ];

%-- Image size:
nx = 640;
ny = 480;


%-- Various other variables (may be ignored if you do not use the Matlab Calibration Toolbox):
%-- Those variables are used to control which intrinsic parameters should be optimized

n_ima = 15;						% Number of calibration images
est_fc = [ 1 ; 1 ];					% Estimation indicator of the two focal variables
est_aspect_ratio = 1;				% Estimation indicator of the aspect ratio fc(2)/fc(1)
center_optim = 1;					% Estimation indicator of the principal point
est_alpha = 0;						% Estimation indicator of the skew coefficient
est_dist = [ 1 ; 1 ; 1 ; 1 ; 0 ];	% Estimation indicator of the distortion coefficients


%-- Extrinsic parameters:
%-- The rotation (omc_kk) and the translation (Tc_kk) vectors for every calibration image and their uncertainties

%-- Image #1:
omc_1 = [ -1.557681e+00 ; -2.205804e+00 ; 1.330361e+00 ];
Tc_1  = [ 1.734034e+02 ; 5.794926e+01 ; 2.044993e+03 ];
omc_error_1 = [ 2.933522e-02 ; 2.081152e-02 ; 3.616192e-02 ];
Tc_error_1  = [ 6.355186e+01 ; 5.156988e+01 ; 3.664085e+01 ];

%-- Image #2:
omc_2 = [ -1.702089e+00 ; -2.256995e+00 ; 1.267502e+00 ];
Tc_2  = [ -6.722390e+01 ; 5.941507e+01 ; 2.057353e+03 ];
omc_error_2 = [ 3.035591e-02 ; 2.055681e-02 ; 3.795895e-02 ];
Tc_error_2  = [ 6.380940e+01 ; 5.186705e+01 ; 3.924807e+01 ];

%-- Image #3:
omc_3 = [ -1.701930e+00 ; -2.253495e+00 ; 1.271626e+00 ];
Tc_3  = [ -2.657159e+02 ; 5.535306e+01 ; 2.111954e+03 ];
omc_error_3 = [ 3.119852e-02 ; 2.203487e-02 ; 3.792260e-02 ];
Tc_error_3  = [ 6.555459e+01 ; 5.345885e+01 ; 4.297524e+01 ];

%-- Image #4:
omc_4 = [ 1.893838e+00 ; 1.951405e+00 ; -6.883375e-01 ];
Tc_4  = [ 1.355395e+02 ; 6.304476e+01 ; 2.007853e+03 ];
omc_error_4 = [ 1.462647e-02 ; 2.105632e-02 ; 3.955605e-02 ];
Tc_error_4  = [ 6.234890e+01 ; 5.068514e+01 ; 3.911636e+01 ];

%-- Image #5:
omc_5 = [ 1.908480e+00 ; 1.850529e+00 ; -5.507656e-01 ];
Tc_5  = [ -9.864709e+01 ; 6.448043e+01 ; 2.021515e+03 ];
omc_error_5 = [ 1.405146e-02 ; 2.113590e-02 ; 3.862142e-02 ];
Tc_error_5  = [ 6.272370e+01 ; 5.106967e+01 ; 4.131143e+01 ];

%-- Image #6:
omc_6 = [ 1.889738e+00 ; 1.980019e+00 ; -7.390048e-01 ];
Tc_6  = [ -3.575459e+02 ; 6.164224e+01 ; 2.073652e+03 ];
omc_error_6 = [ 1.076545e-02 ; 2.434070e-02 ; 4.112093e-02 ];
Tc_error_6  = [ 6.427989e+01 ; 5.275973e+01 ; 4.590561e+01 ];

%-- Image #7:
omc_7 = [ 1.904119e+00 ; 1.613811e+00 ; -2.469117e-01 ];
Tc_7  = [ 1.050648e+02 ; 6.953312e+01 ; 1.959883e+03 ];
omc_error_7 = [ 1.877046e-02 ; 1.939786e-02 ; 3.660657e-02 ];
Tc_error_7  = [ 6.086765e+01 ; 4.946251e+01 ; 3.876840e+01 ];

%-- Image #8:
omc_8 = [ 1.874544e+00 ; 1.387578e+00 ; 5.963331e-03 ];
Tc_8  = [ -1.316064e+02 ; 7.296929e+01 ; 1.962026e+03 ];
omc_error_8 = [ 1.991265e-02 ; 1.966408e-02 ; 3.477026e-02 ];
Tc_error_8  = [ 6.097585e+01 ; 4.958890e+01 ; 3.966239e+01 ];

%-- Image #9:
omc_9 = [ 1.867279e+00 ; 1.338834e+00 ; 5.192820e-02 ];
Tc_9  = [ -3.848199e+02 ; 7.244019e+01 ; 2.003159e+03 ];
omc_error_9 = [ 1.905893e-02 ; 2.014607e-02 ; 3.409265e-02 ];
Tc_error_9  = [ 6.267821e+01 ; 5.108076e+01 ; 4.288011e+01 ];

%-- Image #10:
omc_10 = [ -1.715796e+00 ; -2.041805e+00 ; 9.303852e-01 ];
Tc_10  = [ 1.012077e+02 ; 7.501598e+01 ; 1.710616e+03 ];
omc_error_10 = [ 2.385211e-02 ; 2.111071e-02 ; 3.698204e-02 ];
Tc_error_10  = [ 5.316514e+01 ; 4.311025e+01 ; 3.065417e+01 ];

%-- Image #11:
omc_11 = [ -1.805616e+00 ; -2.089567e+00 ; 8.651741e-01 ];
Tc_11  = [ -6.268099e+01 ; 8.236545e+01 ; 1.672806e+03 ];
omc_error_11 = [ 2.455832e-02 ; 2.181052e-02 ; 3.822892e-02 ];
Tc_error_11  = [ 5.190998e+01 ; 4.218558e+01 ; 3.143920e+01 ];

%-- Image #12:
omc_12 = [ -1.897248e+00 ; -2.132223e+00 ; 7.958098e-01 ];
Tc_12  = [ -2.617251e+02 ; 8.772964e+01 ; 1.655251e+03 ];
omc_error_12 = [ 2.597201e-02 ; 2.298575e-02 ; 3.987007e-02 ];
Tc_error_12  = [ 5.154881e+01 ; 4.202592e+01 ; 3.365145e+01 ];

%-- Image #13:
omc_13 = [ 2.114980e+00 ; 2.117562e+00 ; -3.547934e-01 ];
Tc_13  = [ 3.651036e+01 ; 1.009631e+02 ; 1.516712e+03 ];
omc_error_13 = [ 1.733561e-02 ; 1.778940e-02 ; 4.120690e-02 ];
Tc_error_13  = [ 4.712996e+01 ; 3.839118e+01 ; 3.001941e+01 ];

%-- Image #14:
omc_14 = [ 2.128866e+00 ; 2.219968e+00 ; -5.388805e-01 ];
Tc_14  = [ -6.343915e+01 ; 1.021354e+02 ; 1.517822e+03 ];
omc_error_14 = [ 1.478417e-02 ; 2.098690e-02 ; 4.310996e-02 ];
Tc_error_14  = [ 4.710837e+01 ; 3.841050e+01 ; 2.980588e+01 ];

%-- Image #15:
omc_15 = [ 2.121751e+00 ; 2.168024e+00 ; -4.694731e-01 ];
Tc_15  = [ -2.722483e+02 ; 1.012912e+02 ; 1.548764e+03 ];
omc_error_15 = [ 1.690688e-02 ; 2.488503e-02 ; 4.454520e-02 ];
Tc_error_15  = [ 4.814071e+01 ; 3.949586e+01 ; 3.320000e+01 ];

