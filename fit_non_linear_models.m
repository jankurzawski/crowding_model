
clc
clear
close all

load ./data/tbl_whole_field

crowding_dist = (tbl.crowding_dist);
pa = tbl.polar_angle;
subj = tbl.subjects;
eccentricity = (tbl.eccentricity);
font = tbl.font;


model = 'm3';
options.Display = 'off';


% which font
% 1 Sloan
% 2 Pelli
% 3 both
which_font = 3;

if which_font == 1
    
    
    bad = font == 2;
    crowding_dist(bad) = [];
    pa(bad) = [];
    subj(bad) = [];
    eccentricity(bad) = [];
    font(bad) = [];
    
elseif which_font == 2
    
    
    bad = font == 1;
    crowding_dist(bad) = [];
    pa(bad) = [];
    subj(bad) = [];
    eccentricity(bad) = [];
    font(bad) = [];
    
    
    
elseif which_font == 3
    
    
    
end


nsubj = length(unique(subj));
necc = length(unique(eccentricity));
npa = length(unique(pa));
ndata = length(crowding_dist);
nfont = length(unique(font));

meridian = zeros(npa,ndata)';
subjects = zeros(nsubj,ndata)';
fonts = zeros(nfont,ndata)';


%%
% build meridian predictor with a column of zeros for fovea (1st column)
for m = 1 : npa
    
    meridian(uint8(pa)==m,m) = 1;
    
end

meridian(:,end) = [];

%% subject predictor

for s = 1 : nsubj
    
    subjects(uint8(subj)==s,s) = 1;
    
end

%%
for s = 1 : nfont
    
    fonts(uint8(font)==s,s) = 1;
    
end
%%

X_dm = cat(2,eccentricity,meridian,subjects,fonts);
imagesc(X_dm);
%%
ypred_big = zeros(size(crowding_dist));



% load cross-validation scrambling for reproducibility
load ./data/VF_nonlin

VF_unique = unique(VF);

for v = 1 : length(VF_unique)
    
    ind = VF == VF_unique(v);
    VF_factor(ind) = v;
    
end




for rep = 1 : length(unique(VF_factor))
    
    
    
    vec = VF_factor == rep;
    
    
    
    
    %%
    permvector = zeros(size(crowding_dist));
    permvector(logical(vec)) = 1;
    
    train = logical(abs(permvector-1));
    test = logical(permvector);
    
    
    
    % Setup training dataset
    X_train = X_dm(train,:);
    y_train = crowding_dist(train);
    
    
    b_initial = repmat(0.5,[133 1]);
    
    switch model
        
        case 'm3'
            m = @(b,X) log10((b(1) + X(:,1)).*b(2));
            
        case 'm7'
            m = @(b,X) log10((b(1) + X(:,1).*(X(:,2:5)*b(2:5))));
            
        case 'm8'
            
            m = @(b,X) log10((b(1) + X(:,1).*(X(:,2:5)*b(2:5))) .* X(:,6:6+125) * (b(6:6+125)));
            
        case 'm9'
            
            m = @(b,X) log10((b(1) + X(:,1).*(X(:,2:5)*b(2:5))) .* X(:,6:6+125) * (b(6:6+125)) .* X(:,6+126:end) * (b(6+126:end)));
            
    end
    
    bad = isnan(y_train);
    y_train(bad) = [];
    X_train(bad,:) = [];
    
    objective = @(b) sum((log10(y_train) - m(b,X_train)).^2)./sum((log10(y_train') - mean(log10(y_train))).^2);
    
    
    A = [];
    b = [];
    lb = [];
    ub = [];
    Aeq = [];
    beq = [];
    
    
    switch model
        
        
        
        case 'm3'
            
            h_train =  fmincon(objective,b_initial,A,b,Aeq,beq,lb,ub,[],options);
            
            
        case 'm7'
            
            h_train =  fmincon(objective,b_initial,A,b,Aeq,beq,lb,ub,[],options);
            
            
        case 'm8'
            
            % add constrain so that geomean of Oi (subject factor) = 1 (see
            % constrain2 funciton at the end of the script)
            h_train =  fmincon(objective,b_initial,A,b,Aeq,beq,lb,ub,@(b_initial)constraint2(b_initial),options);
            
            
        case 'm9'
            
            % Set Sloan to 1
            
            Aeq(1,:) = zeros(1,133);
            Aeq(1,end-1) = 1;
            beq = 1;
            h_train =  fmincon(objective,b_initial,A,b,Aeq,beq,lb,ub,@(b_initial)constraint2(b_initial),options);
            
            
            
            
            
            
            
    end
    
    
    big(rep,:) = h_train;
    
    % Setup testing dataset
    
    X_test = X_dm(test,:);
    ypred_big(test) = m(h_train ,X_test);
    
    
    
end
%%

% data

data_test = crowding_dist;
bad = isnan(data_test);
data_test(bad) = [];
ypred_big(bad) = [];

data_test = log10(data_test);
R = 1 - sum((ypred_big - data_test).^2)./sum((data_test - mean(data_test)).^2);
disp(R)




function [c,ceq]=constraint2(b_initial)

c = [];
ceq = 10^(mean(log10(b_initial(6:6+126))))-1;

end

