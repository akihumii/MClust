function sw = SpikeWidth(WV)
%
% sw = SpikeWidth(WV)
%
% INPUTS:
%     WV = tsd of nSpikes x nTrodes (4) x nChannels
%
% OUTPUTS:
%       sw = nSpikes x nTrodes (4) x spike width
%
% ALGO:
%       just time of valley - time of peak 
%       note: if valley preceeds peak, then sw is negative.
%
% ADR 1998
% version L5.1
%
% Status: PROMOTED (Release version) 
% See documentation for copyright (owned by original authors) and warranties (none!).
% This code released as part of MClust 3.0.
% Version control M3.0.

WVD = Data(WV);

[peak, ipeak] = max(WVD, [], 3);
[vlly, ivlly] = min(WVD, [], 3);
sw = ivlly - ipeak;



