function next_patch = getNextVertPatch(cur_patch, patch_list, target_patch, patch_size, overlap, alpha)
    overlap_patch_list = patch_list(1:overlap,:,:,:);
    overlap_cur_patch = cur_patch(patch_size-overlap+1:patch_size,:,:);
    quilting_loss = sum((overlap_patch_list-overlap_cur_patch).^2, [1,2,3]);
    transfer_loss = sum((target_patch-patch_list).^2, [1,2,3]);
    mse = sqrt(squeeze(alpha*quilting_loss + (1-alpha)*transfer_loss));
    [~,index] = min(mse);
    next_patch = patch_list(:,:,:,index);
end
