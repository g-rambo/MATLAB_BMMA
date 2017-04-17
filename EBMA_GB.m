%% EXAUSTIVE BLOCK MATCHING ALGORITHM
% AUTHOR: GRAHAM BALL
% DATE: MARCH 2017
% DESCRIPTION:
% This exaustive search algorithm was written for the ELEC 483 final
% project. The algorithm is used to demonstrate the functionality of the
% EBMA when used for motion estimation on a series of video frames as it
% would be within a video compression algorithm.
%% INPUTS AND OUTPUTS
% INPUTS: Anchor frame, Target frame, Block size, Search window
% OUTPUTS: Motion Vector
%% START OF CODE

function [dmi, dmj, predicted_i] = EBMA_GB(anchor_i, target_i, BlockSize, S_Range)
tic;
% -------------------------------------------------------------------------
% SETTING LOCAL VARIABLES
% -------------------------------------------------------------------------

SRi = S_Range(1);
SRj = S_Range(2);

% Assuming Block is a square for the time being
N = BlockSize(1,1);
% Getting image size
[m,n] = size(anchor_i);

% Partitioning the image into blocks
BlockPartitioned(1,1) = m/N;
BlockPartitioned(1,2) = n/N;

% resetting target and anchor images to doubles
anchor_i = double(anchor_i);
target_i = double(target_i);

% Preallocating space for motion vectors (MAY CAUSE PROBLEMS)
dmi = zeros(BlockPartitioned);
dmj = zeros(BlockPartitioned);
% Preallocating space for predicted image (MAY CAUSE PROBLEMS)
predicted_i = double(zeros(size(target_i)));
% toc;

% -------------------------------------------------------------------------
% ALGORITHM
% -------------------------------------------------------------------------

% For each block, calculate the minimal error and its associated 
% displacement vector

for i = 1:1:BlockPartitioned(1,1)       % Stepping through each block horizontally
    for j = 1:1:BlockPartitioned(1,2)   % Stepping through each block vertically
        
        i1 = (i-1)*N + 1;   % i1,j1 = top left coordinate of the block 
        j1 = (j-1)*N + 1;
        BLOCK_MAD = 1000000;        % Creating a max error value
        
        % Stepping through each candidate in the search range
        for k = max(1,i1-SRi):1:min(m-N+1,i1+SRi)
            for l = max(1,j1-SRj):1:min(n-N+1,j1+SRj)
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
        % Sets the predicted 
        predicted_i(i1:i1+N-1,j1:j1+N-1) = target_i(dmi(i,j)+...
            i1:dmi(i,j)+i1+N-1, dmj(i,j)+j1:dmj(i,j)+j1+N-1);
    end
end
toc;
end

%% END OF CODE