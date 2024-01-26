
function MinDistArray = A2Bdist(A,B)

    % find the min dist of B from each A
    % if the closest FMRP for each LE spine, then A = LE spine and B = FMRP

    % output array of min dist
    MinDistArray = [];
    
    for i = 1:length(A) % loop through all A (to compute closest B)
        SDist = abs(B - A(i)); % scalar distance to this particular A
        minDist = min(SDist);   % find the min dist
        MinDistArray = [MinDistArray; minDist];
    end

end