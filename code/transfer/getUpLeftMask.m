function mask = getUpLeftMask(vertical_boundary,horizontal_boundary,overlap,color_channels)
    mask = zeros(overlap,overlap,color_channels);
    for i=1:overlap
        for j=1:vertical_boundary(i)
            mask(i,j,:)=1;
        end
    end
    for i=1:overlap
        for j=horizontal_boundary(i)+1:overlap
            mask(j,i,:)=0;
        end
    end
end