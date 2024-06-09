function output_im = texture_transfer(source_texture_im, target_texture_path, patch_size, overlap, alpha) 
    target_im = double(imread(target_texture_path));
    [output_x, output_y, color_channels] = size(target_im);

    num_patches_x = 1+floor((output_x-patch_size)/(patch_size-overlap));
    num_patches_y = 1+floor((output_y-patch_size)/(patch_size-overlap));
    output_patches = zeros(num_patches_x*patch_size, num_patches_y*patch_size, color_channels);
    
    patch_list = get_patches(source_texture_im, patch_size, overlap);

    %% Step 0 : Starting Patch

    transfer_loss = sum((patch_list-target_im(1:patch_size,1:patch_size,:)).^2, [1,2,3]);
    [~,index] = min(transfer_loss);
    starting_patch = patch_list(:,:,:,index);
    output_patches(1:patch_size, 1:patch_size, :) = starting_patch;

    %% Step 1 : Fill the first row of the output image

    cur_patch = starting_patch;
    for i=2:num_patches_y
        target_patch = target_im(1:patch_size,(i-1)*(patch_size-overlap)+1:(i-1)*(patch_size-overlap)+patch_size,:);
        next_patch = getNextHorizPatch(cur_patch, patch_list, target_patch, patch_size, overlap, alpha);
        output_patches(1:patch_size, (i-1)*patch_size+1:i*patch_size, :) = next_patch;
        cur_patch = next_patch;
    end
    
    %% Step 2 : Fill the first column of the output image
    
    cur_patch = starting_patch;
    for i=2:num_patches_x
        target_patch = target_im((i-1)*(patch_size-overlap)+1:(i-1)*(patch_size-overlap)+patch_size,1:patch_size,:);
        next_patch = getNextVertPatch(cur_patch, patch_list, target_patch, patch_size, overlap, alpha);
        output_patches((i-1)*patch_size+1:i*patch_size, 1:patch_size, :) = next_patch;
        cur_patch = next_patch;
    end
    
    %% Step 3 : Fill rest of the output image
    
    for i=2:num_patches_x
        for j=2:num_patches_y
            up_patch = output_patches((i-2)*patch_size+1:(i-1)*patch_size,(j-1)*patch_size+1:j*patch_size,:);
            left_patch = output_patches((i-1)*patch_size+1:i*patch_size,(j-2)*patch_size+1:(j-1)*patch_size,:);
            diagonal_patch = output_patches((i-2)*patch_size+1:(i-1)*patch_size,(j-2)*patch_size+1:(j-1)*patch_size,:);
            target_patch = target_im((i-1)*(patch_size-overlap)+1:(i-1)*(patch_size-overlap)+patch_size,(j-1)*(patch_size-overlap)+1:(j-1)*(patch_size-overlap)+patch_size,:);
            next_patch = getNextPatch(up_patch, left_patch, diagonal_patch, patch_list, target_patch, patch_size, overlap, alpha);
            output_patches((i-1)*patch_size+1:i*patch_size,(j-1)*patch_size+1:j*patch_size,:) = next_patch;
        end
    end
    
    %% Step 4 : Calculate Minimum Boundary Cuts
    
    vertical_boundaries = zeros(num_patches_x,num_patches_y-1,patch_size);
    for i=1:num_patches_x
        for j=1:num_patches_y-1
            cur_patch = output_patches((i-1)*patch_size+1:i*patch_size,(j-1)*patch_size+1:j*patch_size,:);
            next_patch = output_patches((i-1)*patch_size+1:i*patch_size,j*patch_size+1:(j+1)*patch_size,:);
            overlap_cur_patch = cur_patch(:,patch_size-overlap+1:patch_size,:);
            overlap_next_patch = next_patch(:,1:overlap,:);
            e = (overlap_cur_patch-overlap_next_patch).^2;
            vertical_boundaries(i,j,:) = BoundaryCut(e, patch_size, overlap);
        end
    end
    
    horizontal_boundaries = zeros(num_patches_x-1,num_patches_y,patch_size);
    for i=1:num_patches_y
        for j=1:num_patches_x-1
            cur_patch = output_patches((j-1)*patch_size+1:j*patch_size,(i-1)*patch_size+1:i*patch_size,:);
            next_patch = output_patches(j*patch_size+1:(j+1)*patch_size,(i-1)*patch_size+1:i*patch_size,:);
            overlap_cur_patch = cur_patch(patch_size-overlap+1:patch_size,:,:);
            overlap_next_patch = next_patch(1:overlap,:,:);
            e = (overlap_cur_patch-overlap_next_patch).^2;
            horizontal_boundaries(j,i,:) = BoundaryCut(rot90(e,3), patch_size, overlap);
        end
    end
    
    %% Step 5 : Construct the output image
    
    output_im = zeros((num_patches_x-1)*(patch_size-overlap)+patch_size, (num_patches_y-1)*(patch_size-overlap)+patch_size, color_channels);
    
    % Fill Horizontal Strips
    up_start = 0;
    for k=1:num_patches_x
        previous_boundary = zeros(patch_size,1)+1;
        leftover = zeros(patch_size,1)+overlap-1;
        for j=1:num_patches_y
           cur_patch = output_patches((k-1)*patch_size+1:k*patch_size,(j-1)*patch_size+1:j*patch_size,:);
           boundary = vertical_boundaries(k,min(j,num_patches_y-1),:);
            for i=1:(patch_size-min(min(k,num_patches_x+1-k),2)*overlap)
                patch_start = (j-1)*(patch_size-overlap);
                left = previous_boundary(i);
                patch_left = previous_boundary(i)-patch_start;
                if j==num_patches_y
                    right = size(output_im,2);
                    patch_right = patch_size;
                else
                    right = left + leftover(i) + patch_size - 2*overlap + boundary(i);
                    patch_right = patch_left + leftover(i) + patch_size - 2*overlap + boundary(i);
                end
                output_im(up_start+i,left:right,:) = cur_patch(min(k-1,1)*overlap+i,patch_left:patch_right,:);
                previous_boundary(i) = right + 1;
                leftover(i) = overlap-boundary(i)-1;
            end
        end
        up_start = up_start+patch_size-min(k-1,1)*overlap;
    end
    
    % Fill Vertical Strips
    left = 0;
    for k=1:num_patches_y
        for j=1:num_patches_x-1
            start = min(k-1,1)*overlap;
            length = patch_size-min(min(k,num_patches_y+1-k),2)*overlap;
            boundary = horizontal_boundaries(j,k,start+1:start+length);
            cur_patch = output_patches((j-1)*patch_size+1:j*patch_size,(k-1)*patch_size+1:k*patch_size,:);
            next_patch = output_patches(j*patch_size+1:(j+1)*patch_size,(k-1)*patch_size+1:k*patch_size,:);
            up = j*(patch_size-overlap);
            down = up+overlap;
            for i=1:length
                gg = cur_patch(patch_size-overlap+1:patch_size-boundary(i),start+i,:);
                gh = next_patch(overlap-boundary(i)+1:overlap,start+i,:);
                output_im(up+1:down-boundary(i),left+i,:) = cur_patch(patch_size-overlap+1:patch_size-boundary(i),start+i,:);
                output_im(down-boundary(i)+1:down,left+i,:) = next_patch(overlap-boundary(i)+1:overlap,start+i,:);
            end
        end
        left = left+patch_size-min(k-1,1)*overlap;
    end
    
    % Fill the remaining gaps
    for i=1:num_patches_x-1
        for j=1:num_patches_y-1
            % Boundaries
            up_boundary = vertical_boundaries(i,j,patch_size-overlap+1:patch_size);
            down_boundary = vertical_boundaries(i+1,j,1:overlap);
            left_boundary = horizontal_boundaries(i,j,patch_size-overlap+1:patch_size);
            right_boundary = horizontal_boundaries(i,j+1,1:overlap);
    
            % Patches
            patch_1 = output_patches((i-1)*patch_size+1:i*patch_size,(j-1)*patch_size+1:j*patch_size,:);
            patch_2 = output_patches((i-1)*patch_size+1:i*patch_size,j*patch_size+1:(j+1)*patch_size,:);
            patch_3 = output_patches(i*patch_size+1:(i+1)*patch_size,(j-1)*patch_size+1:j*patch_size,:);
            patch_4 = output_patches(i*patch_size+1:(i+1)*patch_size,j*patch_size+1:(j+1)*patch_size,:);
    
            gap = patch_2(patch_size-overlap+1:patch_size,1:overlap,:);
    
            % (i) Up-Left Intersection
            positive_mask = getUpLeftMask(up_boundary,left_boundary,overlap,color_channels);
            negative_mask = abs(positive_mask-1);
            gap = gap.*negative_mask + positive_mask.*patch_1(patch_size-overlap+1:patch_size,patch_size-overlap+1:patch_size,:);
    
            % (ii) Down-Left Intersection
            positive_mask = getDownLeftMask(down_boundary,left_boundary,overlap,color_channels);
            negative_mask = abs(positive_mask-1);
            gap = gap.*negative_mask + positive_mask.*patch_3(1:overlap,patch_size-overlap+1:patch_size,:);
    
            % Down-Right Intersection
            positive_mask = getDownRightMask(down_boundary,right_boundary,overlap,color_channels);
            negative_mask = abs(positive_mask-1);
            gap = gap.*negative_mask + positive_mask.*patch_4(1:overlap,1:overlap,:);
    
            % Fill the Gap
            output_im(i*(patch_size-overlap)+1:i*(patch_size-overlap)+overlap,j*(patch_size-overlap)+1:j*(patch_size-overlap)+overlap,:) = gap;
        end
    end
end