function image_saliency = Graphcut_refinement(im, sal)

[m,n,k] = size(im);

%% building graph
imm = double(im);
if (k==3)
    m1=imm(:,:,1);
    m2=imm(:,:,2);
    m3=imm(:,:,3);
else
    m1=imm(:,:,1);
    m2=imm(:,:,1);
    m3=imm(:,:,1);
end

E = edges4connected(m,n);
V=1./(1+sqrt((m1(E(:,1))-m1(E(:,2))).^2+(m2(E(:,1))-m2(E(:,2))).^2+(m3(E(:,1))-m3(E(:,2))).^2));
AA=1000*sparse(E(:,1),E(:,2),0.3*V);
g = fspecial('gauss', [5 5], sqrt(5));

 %% graphcut 
cutim = graphcut(AA,g,sal); 
image_saliency = normalize(cutim);%normalizeImg

end







