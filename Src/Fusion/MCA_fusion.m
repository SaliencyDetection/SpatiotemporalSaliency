function image_saliency = MCA_fusion(imNames)
%%---------------------------set parameters-----------------------------%%
v=0.15; % the value of ln(lamda/l-lamba)
N2=5; % the number of updating time steps

%%-----------------------Input M saliency maps -------------------------%%
M = length(imNames); % the number of incorporated saliency maps

S_M=cell(1,M);
for i=1:M
    im = double(imread(imNames{i}));
    S_M{i} = normalize_1(im,0);
end

[m,n]=size(S_M{1});
    
    %%-----------------Multilayer Cellular Automata--------------------%%
    % compute the threshold 
    threshold=zeros(1,M);    
    for i=1:M                 
        threshold(i)=log(graythresh(S_M{i})/(1-graythresh(S_M{i})));
    end
    
    % record saliency values in th form of ln()
    for i=1:M                
        S_M{i}=log((S_M{i})./(1-S_M{i}));
    end
    coda_2_sign=cell(1,M);   
    
    % update the saliency maps according to rules
    for lap=1:N2
        for i=1:M               
           coda_2_sign{i}=sign(S_M{i}-threshold(i));
        end
        sum2=zeros(m,n);
        for j=1:M           
            sum2=sum2+coda_2_sign{j};
        end

        for i=1:M       
            S_M{i}= S_M{i}+(sum2-coda_2_sign{i})*v;
        end
    end
   
    % restore saliency values from ln()
    for i=1:M 
        S_M{i}=exp(S_M{i})./(1+exp(S_M{i}));
    end
    
    S_M=normalization(S_M,1);
    
    % integrate M updated saliency maps
    S_N2=zeros(m,n);
    for i=1:M
        S_N2=S_N2+S_M{i};
    end
    S_N2=normalization(S_N2,0);

    image_saliency =  S_N2;

end
