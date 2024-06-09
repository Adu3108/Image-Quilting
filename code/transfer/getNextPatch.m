function next_patch = getNextPatch(up_patch, left_patch, diagonal_patch, patch_list, target_patch, patch_size, overlap, alpha)
   upper_patch_list = patch_list(1:overlap,:,:,:);
   overlap_up_patch = up_patch(patch_size-overlap+1:patch_size,:,:);
   upper_difference = (upper_patch_list-overlap_up_patch).^2;
   left_patch_list = patch_list(:,1:overlap,:,:);
   overlap_left_patch = left_patch(:,patch_size-overlap+1:patch_size,:);
   left_difference = (left_patch_list-overlap_left_patch).^2;
   diagonal_patch_list = patch_list(patch_size-overlap+1:patch_size,patch_size-overlap+1:patch_size,:,:);
   overlap_diagonal_patch = diagonal_patch(1:overlap,1:overlap,:);
   diagonal_difference = (overlap_diagonal_patch-diagonal_patch_list).^2;
   transfer_loss = sum((patch_list-target_patch).^2, [1,2,3]);
   quilting_loss = sum(diagonal_difference, [1,2,3]) + sum(left_difference, [1,2,3]) + sum(upper_difference, [1,2,3]);
   mse = sqrt(squeeze(alpha*quilting_loss + (1-alpha)*transfer_loss));
   [~,index] = min(mse);
   next_patch = patch_list(:,:,:,index);
end