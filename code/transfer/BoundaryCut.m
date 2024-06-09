function boundary = BoundaryCut(e, patch_size, overlap)
    E = squeeze(sum(e, 3));
    for i=2:patch_size
        for j=1:overlap
            if j==1
                second_term = min(E(i-1,j), E(i-1,j+1));
            elseif j==overlap
                second_term = min(E(i-1,j-1), E(i-1,j));
            else
                second_term = min([E(i-1,j-1) E(i-1,j) E(i-1,j+1)]);
            end
            E(i,j) = e(i,j) + second_term;
        end
    end
    boundary = zeros(patch_size,1);
    [minimum,below_index] = min(E(patch_size,:));
    boundary(patch_size) = below_index;
    for i=1:patch_size-1
        [~, below_index] = min(abs(E(patch_size-i,:) - (minimum-e(patch_size-i+1,below_index))));
		minimum = E(patch_size-i,below_index);
        boundary(patch_size-i) = below_index;
    end
end