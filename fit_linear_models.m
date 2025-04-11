clc
clear
close all
%%
load tbl_whole_field_eyelink_flank

sel = tbl.eccentricity == 0
tbl(sel,:) = []
%%
% choose model
ct2 = 1;
for m = [3 7 8 9 10]
    
model = sprintf('m%i',m);

% assign variables
crowding_dist = tbl.crowding_dist;
pa = tbl.polar_angle;
subj = tbl.subjects;
eccentricity = tbl.eccentricity;
font = tbl.font;
flank = tbl.flanking;

% find length of predictors and data
nsubj = length(unique(subj));
necc = length(unique(eccentricity));
npa = length(unique(pa));
ndata = length(crowding_dist);
nfont = length(unique(font));
nflank = length(unique(flank));

% initialize preidctors
meridian = zeros(npa,ndata)';
subjects = zeros(nsubj,ndata)';
fonts = zeros(nfont,ndata)';
flankers = zeros(nflank,ndata)';


% build meridian predictor

for m = 1 : npa
    
    meridian(uint8(pa)==m,m) = 1;
    
end


% subject predictor

for s = 1 : nsubj
    
    subjects(uint8(subj)==s,s) = 1;
    
end

% font predictor

for s = 1 : nfont
    
    fonts(uint8(font)==s,s) = 1;
    
end

for m = 1 : nflank
    
    flankers(uint8(flank)==m,m) = 1;
    
end
    
ct = 1;

% for p = 1:4
%     
%     for s = 1 : nsubj
%         
%         tmp = pa == p & subj == s;
%         bouma_mer_subj(tmp,ct) = 1;
%         ct = ct +1;
%     end
%     
% end


uE = unique(eccentricity);
% ct = 1;


%%

switch model
    
    case 'm3'
        
        X = ones(size(meridian,1),1);
        
    case 'm7'
        
        X = cat(2,ones(size(meridian,1),1),meridian);
        
    case 'm8'
        
        X = cat(2,ones(size(meridian,1),1),meridian,flankers);
        
        
    case 'm9'
        
        X = cat(2,ones(size(meridian,1),1),meridian,flankers,font);
        
        
    case 'm10'
        
        X = cat(2,ones(size(meridian,1),1),meridian,subjects,flankers,font,subjects);

end




%%
% initilize a variable to grab predictions in the for loop
ypred_big = zeros(size(crowding_dist));
% 
% 
% 
% VF = repelem([[1:length(crowding_dist)/nsubj]],nsubj);
% 
% VF = VF(randperm(numel(VF)));
% 
% VF_unique = unique(VF);
% 
% for v = 1 : length(VF_unique)
%     
%     ind = VF == VF_unique(v);
%     VF_factor(ind) = v;
%     
% end
% 
% [idxo,prtA]=randDivide([1:size(tbl,1)]',5);

% save('prtAlin','prtA')

load prtAlin
for rep = 1 : length(prtA)-1
    
    
    vec = prtA{rep};
    
    
    
    %% choose data for testing and training
    permvector = zeros(size(crowding_dist));
    permvector(vec) = 1;
    
    train = logical(abs(permvector-1));
    test = logical(permvector);
    
    
    
    % Setup training dataset
    X_train = X(train,:);
    y_train = log10(crowding_dist(train)) - log10(eccentricity(train));
    
    
    h = X_train\y_train;
    
    
    % Setup testing dataset
    X_test = X(test,:);
    
    % predict data
    ypred_test = X_test*h + log10(eccentricity(test));
    
    % with every iteration assing the predicted values to the right place
    % inside the ypred_big variable
    ypred_big(test) = ypred_test;
    
%     
%     subplot(4,3,rep)
%     rep
%     imagesc(test)
end

%%

% data
% bad = isnan(crowding_dist);
% crowding_dist(bad) = [];
% ypred_big(bad) = [];


data_test = log10(crowding_dist);
R2 = 1 - sum((ypred_big - data_test).^2)./sum((data_test - mean(data_test)).^2);
R_pears(ct2) = corr(ypred_big,data_test)
disp(R2)
bigR2(ct2) = R2
ct2 = ct2 + 1

end
function [idxo,prtA]=randDivide(M,K)
[n,~]=size(M);
np=(n-rem(n,K))/K;
[~,idx]=sort(rand(n,1));
C=M(idx,:);
i=1;
j=1;
prtA={};
idxo={};

while i<n-mod(n,K)
    prtA{j}=C(i:i+np-1,:);
    idxo{i}=idx(i:i+np-1,1);
    i=i+np;
    j=j+1;
end
prtA{j}=C(i:n,:);
end
