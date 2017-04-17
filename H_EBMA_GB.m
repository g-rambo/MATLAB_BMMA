%% EXAUSTIVE BLOCK MATCHING ALGORITHM for HBMA (method 2)
% AUTHOR: GRAHAM BALL
% DATE: MARCH 2017
% DESCRIPTION:
% This exaustive search algorithm was written for the ELEC 483 final
% project. The algorithm is used to demonstrate the functionality of the
% EBMA when used for motion estimation on a series of video frames as it
% would be within a video compression algorithm.
%% INPUTS AND OUTPUTS
% INPUTS: Anchor frame, Target frame, Pel accuracy(?), Block size, Search
% range,
% OUTPUTS: Motion Vector
%% Testing Procedure
% The algorithm was first tested with two images train01.tif and
% train02.tif before being called by the main project code.

%% START OF CODE

function [dmi, dmj, predicted_i] = H_EBMA_GB(anchor_i, target_i, BlockSize, S_Range, dl_prev_i, dl_prev_j)

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

% -------------------------------------------------------------------------
% ALGORITHM
% -------------------------------------------------------------------------

% For each block, calculate the minimal error and its associated 
% displacement vector

for i = 1:1:BlockPartitioned(1,1)       % Stepping through each block horizontally
    for j = 1:1:BlockPartitioned(1,2)   % Stepping through each block vertically
        
        i0 = (i-1)*N + 1;   % i0,j0 = top left coordinate of the block 
        j0 = (j-1)*N + 1;
        
        i1 = i0 + (2.*dl_prev_i(ceil(i/2),ceil(j/2)));   % i1,j1 = top left coordinate of vector compensated block 
        j1 = j0 + (2.*dl_prev_j(ceil(i/2),ceil(j/2)));
        BLOCK_MAD = 1000000;        % Creating a max error value
        
        % Stepping through each candidate in the search range
        for k = max(1,i1-SRi):1:min(m-N+1,i1+SRi)
            for l = max(1,j1-SRj):1:min(n-N+1,j1+SRj)
                % Calculating MAD for test candidate
                MAD = sum(sum(abs(target_i(k:k+N-1,l:l+N-1)-...
                    anchor_i(i0:i0+N-1,j0:j0+N-1))));
                
                if MAD < BLOCK_MAD
                    BLOCK_MAD = MAD;    % Sets new MAD error
                    dmi(i,j) = k - i0;  % Sets new block motion vector (i direction)
                    dmj(i,j) = l - j0;  % Sets new block motion vector (j direction)

                end
            end
        end
        % Sets the predicted 
        predicted_i(i0:i0+N-1,j0:j0+N-1) = target_i(dmi(i,j)+...
            i0:dmi(i,j)+i0+N-1, dmj(i,j)+j0:dmj(i,j)+j0+N-1);
    end
end

end

%% END OF CODE