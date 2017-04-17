%% ELEC 483 FINAL PROJECT: MOTION ESTIMATION ALGORITHMS
% AUTHOR: GRAHAM BALL
% DATE: MARCH 2017
% DESCRIPTION:
% This code tests all motion estimation algorithms.
%% CLEAR ALL
clear;
clc;
% -------------------------------------------------------------------------
% -------------------------------------------------------------------------
% -------------------------------------------------------------------------
%% Creation of Variables

% Import anchor and target frames
anchor = imread('train01.tif');
target = imread('train02.tif');
% anchor = imread('frame-8.tif');
% target = imread('frame-10.tif');
[m,n] = size(anchor);
SRi = 8;
SRj = 8;

%% Calling functions

% Run EBMA
disp('Running EBMA');
[EBMA_dmi, EBMA_dmj, EBMA_predicted_i] = EBMA_GB(anchor, target, [4 4], [SRi SRj]);
% Run 3-Step BMA
disp('Running 3Step');
[three_step_dmi, three_step_dmj, three_step_predicted_i] = three_step_GB(anchor, target, [4 4], [SRi SRj]);
% Run the HBMA with EBMA method 1
disp('Running HBMA with EBMA (method 1)')
[HBMA_EBMA_dmi_1, HBMA_EBMA_dmj_1, HBMA_EBMA_predicted_i_1] = EHBMA_GB(anchor, target, [4 4], [SRi SRj], 3);
% Run the HBMA with EBMA method 2
disp('Running HBMA with EBMA (method 2)')
[HBMA_EBMA_dmi_2, HBMA_EBMA_dmj_2, HBMA_EBMA_predicted_i_2] = HBMA_GB_legacy(anchor, target, 3, [4 4], [SRi SRj], @H_EBMA_GB);
% Run the HBMA with 3-Step method 2
disp('Running HBMA with 3-Step')
[HBMA_three_step_dmi, HBMA_three_step_dmj, HBMA_three_step_predicted_i] = HBMA_GB_legacy(anchor, target, 3, [4 4], [SRi SRj], @H_three_step_GB);

%% STATISTICS
% For EBMA
EBMA_error_i = uint8(EBMA_predicted_i) - anchor;
EBMA_psnr = 10*log10(255*255/mean(mean((EBMA_error_i.^2))));
% For 3-Step
three_step_error_i = uint8(three_step_predicted_i) - anchor;
three_step_psnr = 10*log10(255*255/mean(mean((three_step_error_i.^2))));
% For HBMA with EBMA (method 1)
HBMA_EBMA_error_i_1 = uint8(HBMA_EBMA_predicted_i_1) - anchor;
HBMA_EBMA_psnr_1 = 10*log10(255*255/mean(mean((HBMA_EBMA_error_i_1.^2))));
% For HBMA with EBMA (method 2)
HBMA_EBMA_error_i_2 = uint8(HBMA_EBMA_predicted_i_2) - anchor;
HBMA_EBMA_psnr_2 = 10*log10(255*255/mean(mean((HBMA_EBMA_error_i_2.^2))));
% For HBMA with 3-Step (method 2)
HBMA_three_step_error_i = uint8(HBMA_three_step_predicted_i) - anchor;
HBMA_three_step_psnr = 10*log10(255*255/mean(mean((HBMA_three_step_error_i.^2))));

%% PRINTING

% Printing Images for EBMA
N = 4;
figure(1)
subplot(2,2,1)
imshow(anchor)
title('Anchor frame with motion field')
hold on
[if1,jf1] = meshgrid((N+1)/2:N:n,(N+1)/2:N:m);
quiver(if1,jf1,EBMA_dmj,EBMA_dmi)
hold off

subplot(2,2,2)
dmi = -flipud(EBMA_dmi);
dmj = flipud(EBMA_dmj);
quiver(if1,jf1,dmj,dmi)
axis([0 n 0 m]);
title(sprintf('Motion field, search range [%d, %d]',SRi,SRj))

subplot(2,2,3)
imshow(uint8(EBMA_predicted_i))
title(sprintf('Predicted image (PSNR = %.4f)', EBMA_psnr))

subplot(2,2,4)
imshow(uint8(255 - abs(EBMA_error_i)))
title('Prediction-error image (complement)')

% Printing Images for 3-Step
N = 4;
figure(2)
subplot(2,2,1)
imshow(anchor)
title('Anchor frame with motion field')
hold on
[if1,jf1] = meshgrid((N+1)/2:N:n,(N+1)/2:N:m);
quiver(if1,jf1,three_step_dmj,three_step_dmi)
hold off

subplot(2,2,2)
dmi = -flipud(three_step_dmi);
dmj = flipud(three_step_dmj);
quiver(if1,jf1,dmj,dmi)
axis([0 n 0 m]);
title(sprintf('Motion field, search range [%d, %d]',SRi,SRj))

subplot(2,2,3)
imshow(uint8(three_step_predicted_i))
title(sprintf('Predicted image (PSNR = %.4f)', three_step_psnr))

subplot(2,2,4)
imshow(uint8(255 - abs(three_step_error_i)))
title('Prediction-error image (complement)')

% Printing Images for HBMA_EBMA (Method 1)
N = 4;
figure(3)
subplot(2,2,1)
imshow(anchor)
title('Anchor frame with motion field')
hold on
[if2,jf2] = meshgrid((N+1)/2:N:n,(N+1)/2:N:m);
quiver(if2,jf2,HBMA_EBMA_dmj_1,HBMA_EBMA_dmi_1)
hold off

subplot(2,2,2)
dmi = -flipud(HBMA_EBMA_dmi_1);
dmj = flipud(HBMA_EBMA_dmj_1);
quiver(if2,jf2,dmj,dmi)
axis([0 n 0 m]);
title(sprintf('Motion field, search range [%d, %d]',SRi,SRj))

subplot(2,2,3)
imshow(uint8(HBMA_EBMA_predicted_i_1))
title(sprintf('Predicted image (PSNR = %.4f)', HBMA_EBMA_psnr_1))

subplot(2,2,4)
imshow(uint8(255 - abs(HBMA_EBMA_error_i_2)))
title('Prediction-error image (complement)')

% Printing Images for HBMA_EBMA (Method 1)
N = 4;
figure(4)
subplot(2,2,1)
imshow(anchor)
title('Anchor frame with motion field')
hold on
[if2,jf2] = meshgrid((N+1)/2:N:n,(N+1)/2:N:m);
quiver(if2,jf2,HBMA_EBMA_dmj_2,HBMA_EBMA_dmi_2)
hold off

subplot(2,2,2)
dmi = -flipud(HBMA_EBMA_dmi_2);
dmj = flipud(HBMA_EBMA_dmj_2);
quiver(if2,jf2,dmj,dmi)
axis([0 n 0 m]);
title(sprintf('Motion field, search range [%d, %d]',SRi,SRj))

subplot(2,2,3)
imshow(uint8(HBMA_EBMA_predicted_i_2))
title(sprintf('Predicted image (PSNR = %.4f)', HBMA_EBMA_psnr_2))

subplot(2,2,4)
imshow(uint8(255 - abs(HBMA_EBMA_error_i_2)))
title('Prediction-error image (complement)')

% Printing Images for HBMA_3-Step
N = 4;
figure(5)
subplot(2,2,1)
imshow(anchor)
title('Anchor frame with motion field')
hold on
[if2,jf2] = meshgrid((N+1)/2:N:n,(N+1)/2:N:m);
quiver(if2,jf2,HBMA_three_step_dmj,HBMA_three_step_dmi)
hold off

subplot(2,2,2)
dmi = -flipud(HBMA_three_step_dmi);
dmj = flipud(HBMA_three_step_dmj);
quiver(if2,jf2,dmj,dmi)
axis([0 n 0 m]);
title(sprintf('Motion field, search range [%d, %d]',SRi,SRj))

subplot(2,2,3)
imshow(uint8(HBMA_three_step_predicted_i))
title(sprintf('Predicted image (PSNR = %.4f)', HBMA_three_step_psnr))

subplot(2,2,4)
imshow(uint8(255 - abs(HBMA_three_step_error_i)))
title('Prediction-error image (complement)')

% -------------------------------------------------------------------------
% -------------------------------------------------------------------------
% -------------------------------------------------------------------------
