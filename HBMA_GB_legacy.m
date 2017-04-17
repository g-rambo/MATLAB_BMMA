%% HIERCHICHAL BLOCK MATCHING ALGORITHM
% AUTHOR: GRAHAM BALL
% DATE: MARCH 2017
% DESCRIPTION:
% This hierarchichal block matching algorithm was written for the ELEC 483 
% final project. The algorithm is used to demonstrate the functionality of
% the HBMA when used for motion estimation on a series of video frames as 
% it would be within a video compression algorithm. This function calls on
% other search algorithms such as the EBMA or the 3 step algorithm.
%% INPUTS AND OUTPUTS
% INPUTS: Anchor frame, Target frame, Number of levels, Block size, Search
% range, Search algorithm
% OUTPUTS: Motion Vector


%% START OF CODE

function [dmi, dmj, predicted_i] = HBMA_GB_legacy(anchor_i, target_i, Levels, BlockSize, S_Range, fun)

% -------------------------------------------------------------------------
% SETTING LOCAL VARIABLES
% -------------------------------------------------------------------------
% -------------------------------------------------------------------------
% Search range at each level
% -------------------------------------------------------------------------

% SRi = S_Range(1)/(2^(Levels-1));
% SRj = S_Range(2)/(2^(Levels-1));

% Assuming Block is a square for the time being
N = BlockSize(1,1);

my_mean = @(block_struct) ...
   mean(mean(block_struct.data) * ones(size(block_struct.data)));

%% ATTEMPTING TO RESOLVE CODING ISSUE
% Averaging image pixels for each level.... (Not sure if this is correct)
% 
% AI_meaned_3 = anchor_i;
% AI_meaned_2 = blockproc(AI_meaned_3, [N/2 N/2], my_mean);
% AI_meaned_1 = blockproc(AI_meaned_2, [N/2 N/2], my_mean);
% 
% TI_meaned_3 = target_i;
% TI_meaned_2 = blockproc(TI_meaned_3, [N/2 N/2], my_mean);
% TI_meaned_1 = blockproc(TI_meaned_2, [N/2 N/2], my_mean);

% -------------------------------------------------------------------------
% ALGORITHM
% -------------------------------------------------------------------------
dmi = zeros(size(anchor_i));
dmj = zeros(size(anchor_i));

% START WITH ONE LEVEL.....


tic;
for i = 1:1:Levels
    AI_meaned = anchor_i;
    TI_meaned = target_i;
    SRi = ceil((S_Range(1)/(2^(Levels-i)))/3);
    SRj = ceil((S_Range(2)/(2^(Levels-i)))/3);
    for j = i+1:1:Levels
        AI_meaned = blockproc(AI_meaned, [N/2 N/2], my_mean);
        TI_meaned = blockproc(TI_meaned, [N/2 N/2], my_mean);
    end

    [dmi, dmj, predicted_i] = fun(AI_meaned, TI_meaned, BlockSize, [SRi SRj], dmi, dmj);

end

% [dmi, dmj, predicted_i] = fun(AI_meaned_1, TI_meaned_1, BlockSize, [SRi SRj], dmi, dmj);
% 
% % IMPLEMENT SECOND LEVEL....
% 
% [dmi, dmj, predicted_i] = fun(AI_meaned_2, TI_meaned_2, BlockSize, [SRi SRj], dmi, dmj);
% 
% % IMPLEMENT THIRD LEVEL....
% 
% [dmi, dmj, predicted_i] = fun(AI_meaned_3, TI_meaned_3, BlockSize, [SRi SRj], dmi, dmj);

%% OLD CODE

% % Number of blocks in each level
% N_H = zeros(2, Levels);
% for i = 1:1:(Levels)
%     N_H(1,i) = m/((2^(Levels-i)) * N);
%     N_H(2,i) = n/((2^(Levels-i)) * N);
% end
% 
% % Averaging image pixels for each level.... (Not sure if this is correct)
% 
% my_mean = @(block_struct) ...
%    mean(mean(block_struct.data) * ones(size(block_struct.data)));
% 
% AI_meaned_3 = anchor_i;
% AI_meaned_2 = blockproc(AI_meaned_3, [N/2 N/2], my_mean);
% AI_meaned_1 = blockproc(AI_meaned_2, [N/2 N/2], my_mean);
% 
% TI_meaned_3 = target_i;
% TI_meaned_2 = blockproc(TI_meaned_3, [N/2 N/2], my_mean);
% TI_meaned_1 = blockproc(TI_meaned_2, [N/2 N/2], my_mean);
% 
% % -------------------------------------------------------------------------
% % ALGORITHM
% % -------------------------------------------------------------------------
% 
% % START WITH ONE LEVEL.....
% 
% [d1i, d1j, Predicted_1] = fun(AI_meaned_1, TI_meaned_1, BlockSize, [SRi SRj], zeros(size(AI_meaned_1)), zeros(size(AI_meaned_1)));
% 
% % IMPLEMENT SECOND LEVEL....
% 
% [d2i, d2j, Predicted_2] = fun(AI_meaned_2, TI_meaned_2, BlockSize, [SRi SRj], d1i, d1j);
% 
% % IMPLEMENT THIRD LEVEL....
% 
% [d3i, d3j, Predicted_3] = fun(AI_meaned_3, TI_meaned_3, BlockSize, [SRi SRj], d2i, d2j);
% 
% predicted_i = Predicted_3;
% dmi = d3i;
% dmj = d3j;
toc;

end

%% END OF CODE