image_path = "../../results/Input/texture13.png";
color_channels = size(double(imread(image_path)),3);
patch_size = 60;
factor = 6;
output_x = 400;
output_y = 400;

overlap = floor(patch_size/factor);
boundary = floor(0.5*overlap);
num_patches_x = floor(output_x/(patch_size-overlap+boundary));
num_patches_y = floor(output_y/(patch_size-overlap+boundary));
output_patches = zeros(num_patches_x*patch_size, num_patches_y*patch_size, color_channels);

patch_list = get_patches(image_path, patch_size, factor);
available_patches = size(patch_list, 4);
% starting_patch = patch_list(:,:,:,randi([1 available_patches],1));
starting_patch = patch_list(:,:,:,1);

output_patches(1:patch_size, 1:patch_size, :) = starting_patch;

%% Step 1 : Fill the first row of the output image

cur_patch = starting_patch;
for i=2:num_patches_y
    next_patch = getNextHorizPatch(cur_patch, patch_list, patch_size, overlap);
    output_patches(1:patch_size, (i-1)*patch_size+1:i*patch_size, :) = next_patch;
    cur_patch = next_patch;
end

%% Step 2 : Fill the first column of the output image

cur_patch = starting_patch;
for i=2:num_patches_x
    next_patch = getNextVertPatch(cur_patch, patch_list, patch_size, overlap);
    output_patches((i-1)*patch_size+1:i*patch_size, 1:patch_size, :) = next_patch;
    cur_patch = next_patch;
end

%% Step 3 : Fill rest of the output image

for i=2:num_patches_x
    for j=2:num_patches_y
        up_patch = output_patches((i-2)*patch_size+1:(i-1)*patch_size,(j-1)*patch_size+1:j*patch_size,:);
        left_patch = output_patches((i-1)*patch_size+1:i*patch_size,(j-2)*patch_size+1:(j-1)*patch_size,:);
        next_patch = getNextPatch(up_patch, left_patch, patch_list, patch_size, overlap);
        output_patches((i-1)*patch_size+1:i*patch_size,(j-1)*patch_size+1:j*patch_size,:) = next_patch;
    end
end

%% Step 4 : Construct the output image

output_im = zeros(num_patches_x*(patch_size-overlap+boundary), num_patches_y*(patch_size-overlap+boundary), color_channels);
for i=1:num_patches_x
    for j=1:num_patches_y
        cur_patch = output_patches((i-1)*patch_size+1:i*patch_size,(j-1)*patch_size+1:j*patch_size,:);
        cropped_patch = cur_patch(1:patch_size-overlap+boundary,1:patch_size-overlap+boundary,:);
        output_im((i-1)*(patch_size-overlap+boundary)+1:i*(patch_size-overlap+boundary),(j-1)*(patch_size-overlap+boundary)+1:j*(patch_size-overlap+boundary),:) = cropped_patch;
    end
end

imwrite(output_im/255, "../../results/Quilting/2/output13.png");

%% Utility Functions

function next_patch = getNextHorizPatch(cur_patch, patch_list, patch_size, overlap)
    overlap_patch_list = patch_list(:,1:overlap,:,:);
    overlap_cur_patch = cur_patch(:,patch_size-overlap+1:patch_size,:);
    difference = (overlap_patch_list-overlap_cur_patch).^2;
    mse = sqrt(squeeze(sum(difference, [1,2,3])));
    [~,index] = min(mse);
    next_patch = patch_list(:,:,:,index);
end

function next_patch = getNextVertPatch(cur_patch, patch_list, patch_size, overlap)
    overlap_patch_list = patch_list(1:overlap,:,:,:);
    overlap_cur_patch = cur_patch(patch_size-overlap+1:patch_size,:,:);
    difference = (overlap_patch_list-overlap_cur_patch).^2;
    mse = sqrt(squeeze(sum(difference, [1,2,3])));
    [~,index] = min(mse);
    next_patch = patch_list(:,:,:,index);
end

function next_patch = getNextPatch(up_patch, left_patch, patch_list, patch_size, overlap)
   upper_patch_list = patch_list(1:overlap,:,:,:);
   overlap_up_patch = up_patch(patch_size-overlap+1:patch_size,:,:);
   upper_difference = (upper_patch_list-overlap_up_patch).^2;
   left_patch_list = patch_list(:,1:overlap,:,:);
   overlap_left_patch = left_patch(:,patch_size-overlap+1:patch_size,:);
   left_difference = (left_patch_list-overlap_left_patch).^2;
   mse = sqrt(squeeze(sum(left_difference, [1,2,3]) + sum(upper_difference, [1,2,3])));
   [~,index] = min(mse);
   next_patch = patch_list(:,:,:,index);
end