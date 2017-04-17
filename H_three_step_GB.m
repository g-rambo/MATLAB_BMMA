%% HIERARCHICAL 3-STEP BLOCK MATCHING ALGORITHM (method 2)
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
% range, previous motion vectors
% OUTPUTS: Motion Vector
%% Testing Procedure
% The algorithm was first tested with two images train01.tif and
% train02.tif before being called by the main project code.

%% START OF CODE

function [dmi, dmj, predicted_i] = H_three_step_GB(anchor_i, target_i, BlockSize, S_Range, dl_prev_i, dl_prev_j)

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
for Step = 1:1:3
    Ri = ceil(SRi/(2^Step));
    Rj = ceil(SRj/(2^Step));
    if Step == 3
        Ri = 1;
        Rj = 1;
    end
    for i = 1:1:BlockPartitioned(1,1)       % Stepping through each block horizontally
        for j = 1:1:BlockPartitioned(1,2)   % Stepping through each block vertically
        
            i0 = (i-1)*N + 1;   % i0,j0 = top left coordinate of the block 
            j0 = (j-1)*N + 1;
        
            i1 = i0 + (2.*dl_prev_i(ceil(i/2),ceil(j/2)));   % i1,j1 = top left coordinate of vector compensated block 
            j1 = j0 + (2.*dl_prev_j(ceil(i/2),ceil(j/2)));
            BLOCK_MAD = 1000000;        % Creating a max error value
        
            % Stepping through each candidate in the search range
            for k = max(1,i1-Ri):Ri:min(m-N+1,i1+Ri)
                for l = max(1,j1-Rj):Rj:min(n-N+1,j1+Rj)
                    if k==0 && l==0 && Step ~= 1
                    else
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
            end
            % Sets the predicted 
            predicted_i(i0:i0+N-1,j0:j0+N-1) = target_i(dmi(i,j)+...
                i0:dmi(i,j)+i0+N-1, dmj(i,j)+j0:dmj(i,j)+j0+N-1);
        end
    end
end

end

%% END OF CODE