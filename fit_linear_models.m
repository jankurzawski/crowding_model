clc
clear
close all
%%

% choose model
model = 'm9';


% pick data

sloan_only = 1;

if sloan_only
    
    load ./data/tbl_sloan % data for sloan in the periphery
    
else
    
    load ./data/tbl_sloan_pelli % data for sloan and pelli in the periphery
    
end


% assign variables
crowding_dist = tbl.crowding_dist;
pa = tbl.polar_angle;
subj = tbl.subjects;
eccentricity = tbl.eccentricity;
font = tbl.font;

% find length of predictors and data
nsubj = length(unique(subj));
necc = length(unique(eccentricity));
npa = length(unique(pa));
ndata = length(crowding_dist);
nfont = length(unique(font));

% initialize preidctors
meridian = zeros(npa,ndata)';
subjects = zeros(nsubj,ndata)';
fonts = zeros(nfont,ndata)';


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


ct = 1;

for p = 1:4
    
    for s = 1 : nsubj
        
        tmp = pa == p & subj == s;
        bouma_mer_subj(tmp,ct) = 1;
        ct = ct +1;
    end
    
end


uE = unique(eccentricity);
ct = 1;




switch model
    
    case 'm3'
        
        X = ones(size(meridian,1),1);
        
    case 'm7'
        
        X = cat(2,ones(size(meridian,1),1),meridian);
        
    case 'm8'
        
        X = cat(2,ones(size(meridian,1),1),meridian,subjects);
        
        
    case 'm9'
        
        X = cat(2,ones(size(meridian,1),1),meridian,subjects,font);
        
   
        
  

        
end




%%
% initilize a variable to grab predictions in the for loop
ypred_big = zeros(size(crowding_dist));



load ./data/VF
    



VF_unique = unique(VF);


for rep = VF_unique
    
    
    vec = VF == rep;
    
    %% choose data for testing and training
    permvector = zeros(size(crowding_dist));
    permvector(logical(vec)) = 1;
    
    train = logical(abs(permvector-1));
    test = logical(permvector);
    
    
    
    % Setup training dataset
    X_train = X(train,:);    
    y_train = log10(crowding_dist(train)) - log10(eccentricity(train));
    
    
    % remove nans, otherwise the model is not solved
    bad = isnan(y_train);
    y_train(bad) = [];
    X_train(bad,:) = [];
    
    h = X_train\y_train;
    
    
    % Setup testing dataset
    X_test = X(test,:);
    
    % predict data
    ypred_test = X_test*h + log10(eccentricity(test));
    
    % with every iteration assing the predicted values to the right place
    % inside the ypred_big variable
    ypred_big(test) = ypred_test;
    
    
    
end

%%

% data
bad = isnan(crowding_dist);
crowding_dist(bad) = [];
ypred_big(bad) = [];


data_test = log10(crowding_dist);
R2 = 1 - sum((ypred_big - data_test).^2)./sum((data_test - mean(data_test)).^2);
disp(R2)


