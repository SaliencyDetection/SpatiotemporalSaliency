function mag = computeMagnitude(flow)
    vx = flow(:,:,1);
    vy = flow(:,:,2);
    
    mag = sqrt(vx .^ 2 + vy .^ 2);
end