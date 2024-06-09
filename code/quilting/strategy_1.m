image_path = "../../results/Input/texture13.png";
color_channels = size(imread(image_path),3);
patch_size = 60;
factor = 6;
output_x = 360;
output_y = 360;

output_im = zeros(output_x,output_y,color_channels);
num_patches_x = floor(output_x/patch_size);
num_patches_y = floor(output_y/patch_size);
total_patches = num_patches_x*num_patches_y;

patch_list = get_patches(image_path, patch_size, factor);
available_patches = size(patch_list, 4);
rng(0,"twister");
sequence = randi([1 available_patches],1,total_patches);

for i=1:num_patches_x
    for j=1:num_patches_y
        index = sequence(num_patches_y*(i-1) + j);
        cur_patch = patch_list(:,:,:,index);
        left = 1 + (j-1)*patch_size;
        right = j*patch_size;
        up = 1 + (i-1)*patch_size;
        down = i*patch_size;
        output_im(up:down,left:right,:) = cur_patch;
    end
end

imwrite(output_im/255, '../../results/Quilting/1/output13.png');