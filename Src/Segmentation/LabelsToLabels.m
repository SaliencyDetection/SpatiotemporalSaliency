function output = LabelsToLabels(L)
label = unique(L(:));

output = L;

for i=1:length(label)
    output(L==label(i)) = i;
end

end