%% HIERCHICHAL BLOCK MATCHING ALGORITHM (Method 1)
% AUTHOR: GRAHAM BALL
% DATE: MARCH 2017
% DESCRIPTION:
% This hierarchichal block matching algorithm was written for the ELEC 483 
% final project. The algorithm is used to demonstrate the functionality of
% the HBMA when used for motion estimation on a series of video frames as 
% it would be within a video compression algorithm. This function calls on
% other search algorithms such as the EBMA or the 3 step algorithm.
%% INPUTS AND OUTPUTS
% INPUTS: Anchor frame, Target frame, Number of levels, Search algorithm, Block size, Search
% range,
% OUTPUTS: Motion Vector
%% START OF CODE
function [dmi, dmj, predicted_i] = EHBMA_GB(anchor_i, target_i, BlockSize, S_Range, Levels)

tic;

% -------------------------------------------------------------------------
% SETTING LOCAL VARIABLES
% -------------------------------------------------------------------------

% Assuming Block is a square for the time being
N = BlockSize(1,1);
% Getting image size
[m,n] = size(anchor_i);

% resetting target and anchor images to doubles
anchor_i = double(anchor_i);
target_i = double(target_i);

% Preallocating space for motion vectors (MAY CAUSE PROBLEMS)
dmi = zeros(m/(N*(2^(Levels-1))));
dmj = zeros(n/(N*(2^(Levels-1))));

% Preallocating space for predicted image (MAY CAUSE PROBLEMS)
predicted_i = double(zeros(size(target_i)));

% -------------------------------------------------------------------------
% ALGORITHM
% -------------------------------------------------------------------------


for f = 1:1:Levels
    % Setting the search range
    SRi = ceil((S_Range(1)/(2^(Levels-f)))/3);
    SRj = ceil((S_Range(2)/(2^(Levels-f)))/3);
    
    % Partitioning the image into blocks
    BlockPartitioned(1,1) = m/(N*(2^(Levels-f)));
    BlockPartitioned(1,2) = n/(N*(2^(Levels-f)));
    dmi_prev = dmi;
    dmj_prev = dmj;
    dmi = zeros(BlockPartitioned);
    dmj = zeros(BlockPartitioned);
    H_step = 1*(2^(Levels-f));
    
    % For each block, calculate the minimal error and its associated 
    % displacement vector
    for i = 1:1:BlockPartitioned(1,1)       % Stepping through each block horizontally
        for j = 1:1:BlockPartitioned(1,2)   % Stepping through each block vertically
        
            % i0,j0 = top left coordinate of the block
            i1 = (i-1)*N + 1; 
            j1 = (j-1)*N + 1;
        
            % i1,j1 = top left coordinate of vector adjusted block
            i0 = i1 + (2.*dmi_prev(ceil(i/2),ceil(j/2))); 
            j0 = j1 + (2.*dmj_prev(ceil(i/2),ceil(j/2)));

            BLOCK_MAD = 1000000;        % Creating a max error value
        
            % Stepping through each candidate in the search range
            for k = max(1,i0-SRi):H_step:min(m-N+1,i0+SRi)
                for l = max(1,j0-SRj):H_step:min(n-N+1,j0+SRj)
                    
                    % Calculating MAD for test candidate
                    MAD = sum(sum(abs(target_i(k:k+N-1,l:l+N-1)-...
                        anchor_i(i1:i1+N-1,j1:j1+N-1))));                
                    if MAD < BLOCK_MAD
                        BLOCK_MAD = MAD;    % Sets new MAD error
                        dmi(i,j) = k - i1;  % Sets new block motion vector (i direction)
                        dmj(i,j) = l - j1;  % Sets new block motion vector (j direction)
                    end
                    
                end
            end
            
            if f == Levels
            % Sets the predicted 
            predicted_i(i1:i1+N-1,j1:j1+N-1) = target_i(dmi(i,j)+...
                i1:dmi(i,j)+i1+N-1, dmj(i,j)+j1:dmj(i,j)+j1+N-1);
            else
            end
            
        end
    end
    
end

toc;

end