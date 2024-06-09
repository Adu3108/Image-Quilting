function patch_list = get_patches(im, patch_size, overlap)
    increment = patch_size - overlap;
    
    [x,y,z] = size(im);
    num_patches_x = 1+floor((x-patch_size)/(patch_size-overlap));
    num_patches_y = 1+floor((y-patch_size)/(patch_size-overlap));
    total_patches = num_patches_x * num_patches_y;
    patch_list = zeros(patch_size, patch_size, z, total_patches);
    
    up = 1;
    down = patch_size;
    iter = 1;
    while down < x
        left = 1;
        right = patch_size;
        while right < y
            cur_patch = im(up:down, left:right, :);
            left = left + increment;
            right = right + increment;
            patch_list(:,:,:,iter) = cur_patch;
            iter = iter + 1;
        end
        up = up + increment;
        down = down + increment;
    end
end