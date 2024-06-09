image_path = "../../results/Source/source1.png";
target_texture_path = "../../results/Target/srk.jpeg";
patch_size = 60;
overlap = 10;
N = 5;

im = double(imread(image_path));
% target_im = double(imread(target_texture_path));
% [x,y,~] = size(target_im);
% mask = zeros(size(target_im))+1;
% for i=1:y
%     for j=1:x
%         if target_im(j,i)==0
%             mask(j,i)=0;
%         else 
%             break;
%         end
%     end
%     for j=x:-1:1
%         if target_im(j,i)==0
%             mask(j,i)=0;
%         else 
%             break;
%         end
%     end
% end

for i=1:N
    alpha = 0.1 + 0.8*(i-1)/(N-1);
    im = texture_transfer(im, target_texture_path, patch_size, ceil(overlap), alpha);
    patch_size = patch_size-10;
    overlap = overlap-2;
end

% [output_x,output_y,~]=size(im);
% x_diff = x-output_x;
% y_diff = y-output_y;
% mask = mask(floor(x_diff/2)+1:x-ceil(x_diff/2),floor(y_diff/2)+1:y-ceil(y_diff/2),:);
% imwrite((mask.*im)/255, "../../results/Transfer/transfer_output_1.png");
imwrite(im/255, "../../results/Transfer/transfer_output_2.png");