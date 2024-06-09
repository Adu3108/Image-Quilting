function mask = getDownRightMask(vertical_boundary,horizontal_boundary,overlap,color_channels)
    mask = zeros(overlap,overlap,color_channels);
    for i=1:overlap
        for j=vertical_boundary(i)+1:overlap
            mask(i,j,:)=1;
        end
    end
    for i=1:overlap
        for j=1:horizontal_boundary(i)
            mask(j,i,:)=0;
        end
    end
end