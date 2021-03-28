figure(5)
subplot(1,2,1)

load ./data/data

x = [data.Eccm2_5__0_0   data.Eccm5_0__0_0 data.Eccm10_0__0_0];
y = [data.Ecc2_5__0_0   data.Ecc5_0__0_0 data.Ecc10_0__0_0];

x1(1,:) = (data.Eccm2_5__0_0);
x1(2,:) = (data.Eccm5_0__0_0);
x1(3,:) = (data.Eccm10_0__0_0);

y1(1,:) = (data.Ecc2_5__0_0);
y1(2,:) = (data.Ecc5_0__0_0);
y1(3,:) = (data.Ecc10_0__0_0);


sss = 300
isnanx = find(isnan(x));
x(isnanx) = [];
y(isnanx) = [];


isnany = find(isnan(y));
x(isnany) = [];
y(isnany) = [];



n = length(x);                %// number of colors
clear ccmap
ccmap(1,:) = round([143 208 142]/255,2);   %// color first row - red
ccmap(2,:) = round([159 202 223]/255,2);   %// color 25th row - green
ccmap(3,:) = round([253 192 140]/255,2);   %// color 50th row - blue

[X,Y] = meshgrid([1:3],[1:length(x)]);  %// mesh of indices


for e = 1 : size(x1,1)
    
    myx = x1(e,:);
    myy = y1(e,:);
    
    isnanx = find(isnan(myx));
    myx(isnanx) = [];
    myy(isnanx) = [];
    
    
    scatter(myx,myy,sss*ones([1,length(myx)]),ccmap(e,:),'.'); hold on
end


pp = polyfit((x),(y),1); hold on
[R,p] = corr((x)',(y)','type','Pearson')
xlim([0.1 5])
ylim([0.1 5])
% plot(xlim,xlim*pp(1)+pp(2),'-','linewidth',2,'Color',[0 0 0 1])
plot(xlim,xlim,'--','Color',[0 0 0 0.8])


a = (isfinite(data.Eccm2_5__0_0));
b = (isfinite(data.Eccm5_0__0_0));
c = (isfinite(data.Eccm10_0__0_0));

left_meridian_n = size(data.Eccm2_5__0_0,2) - length(find((a+b+c) == 0))

a = (isfinite(data.Ecc2_5__0_0));
b = (isfinite(data.Ecc5_0__0_0));
c = (isfinite(data.Ecc10_0__0_0));

right_meridian_n = size(data.Eccm2_5__0_0,2) - length(find((a+b+c) == 0));


title(sprintf('R = %.2f N = %i',R,right_meridian_n))
% txt = str = '$$ \int_{0}^{2} x^2\sin(x) dx $$';


% title

ylabel('Right meridian (deg)')
xlabel('Left meridian (deg)')

% colormap(ccmap)
axis image
% xlim([-1 1])
% ylim([-1 1])

set(gca,'yscale','log')
set(gca,'xscale','log')
plot(xlim,xlim,'--','Color',[0 0 0 0.8])
set(gca,'Fontsize',15)
ylim([xlim])
% axis square
% set(gca,'DataAspectRatio',[1 0.5 1])

figg = gca;
findN = strfind(figg.Title.String,'N')
% findp = strfind(figg.Title.String,'p')

figg.Title.String = cat(2,' {\it R}',figg.Title.String(2:findN-2))
xticks([0.1 1])
%%
subplot(1,2,2)


figure(5)
x = [data.Ecc0_0__m2_5 data.Ecc0_0__m5_0 data.Ecc0_0__m10_0];
y = [data.Ecc0_0__2_5 data.Ecc0_0__5_0 data.Ecc0_0__10_0];



y1(1,:) = (data.Ecc0_0__m2_5)
y1(2,:) = (data.Ecc0_0__m5_0)
y1(3,:) = (data.Ecc0_0__m10_0)

x1(1,:) = (data.Ecc0_0__2_5)
x1(2,:) = (data.Ecc0_0__5_0)
x1(3,:) = (data.Ecc0_0__10_0)


sss = 300
isnanx = find(isnan(x));
x(isnanx) = [];
y(isnanx) = [];


isnany = find(isnan(y));
x(isnany) = [];
y(isnany) = [];

n = length(x);                %// number of colors
clear ccmap
ccmap(1,:) = round([143 208 142]/255,2);   %// color first row - red
ccmap(2,:) = round([159 202 223]/255,2);   %// color 25th row - green
ccmap(3,:) = round([253 192 140]/255,2);   %// color 50th row - blue

[X,Y] = meshgrid([1:3],[1:length(x)]);  %// mesh of indices

% ccmap = interp2(X([1,length(x)/2,length(x)],:),Y([1,length(x)/2,length(x)],:),ccmap,X,Y); %// interpolate colormap
% colormap(cmap) %// set color map

%  c = cbrewer('qual','Accent',length(x))
for e = 1 : size(x1,1)
    
    myx = x1(e,:);
    myy = y1(e,:);
    
    isnanx = find(isnan(myx));
    myx(isnanx) = [];
    myy(isnanx) = [];
    
    
    scatter(myx,myy,sss*ones([1,length(myx)]),ccmap(e,:),'.'); hold on
end%

pp = polyfit(x,y,1); hold on
plot(xlim,xlim,'--','Color',[0 0 0 0.8])


[R,p] = corr((x)',(y)','type','Pearson')

% plot(xlim,xlim*pp(1)+pp(2),'-','linewidth',2,'Color',[0 0 0 1])

a = (isfinite(data.Ecc0_0__m2_5));
b = (isfinite(data.Ecc0_0__m5_0));
c = (isfinite(data.Ecc0_0__m10_0));

lower_meridian_n = size(data.Eccm2_5__0_0,2) - length(find((a+b+c) == 0))

a = (isfinite(data.Ecc0_0__2_5));
b = (isfinite(data.Ecc0_0__5_0));
c = (isfinite(data.Ecc0_0__10_0));


upper_meridian_n = size(data.Eccm2_5__0_0,2) - length(find((a+b+c) == 0));





title(sprintf('R = %.2f N = %i',R,upper_meridian_n))
plot(xlim,xlim,'--','Color',[0 0 0 0.8])

axis image
xlim([0.1 5])
ylim([0.1 5])
% xlim([0 6])
% ylim([0 6])
xlabel('Upper meridian (deg)')
ylabel('Lower meridian (deg)')
set(gca,'yscale','log')
set(gca,'xscale','log')
plot(xlim,xlim,'--','Color',[0 0 0 0.8])

set(gca,'Fontsize',15)
ylim([xlim])
figg = gca;
figg.Title.String = cat(2,' {\it R}',figg.Title.String(2:findN-2))

sgtitle('Crowding along two meridians','FontWeight','bold','FontSize',15)
set(gcf,'Position',[560   480   796   468])

% 
legend box off

[leg2,icons] = legend({sprintf('2.5%s',char(176));sprintf('5%s',char(176));sprintf('10%s',char(176))})
leg2.Location = 'southEast';
% title(leg2,'Radial eccentricity','fontsize',15);

% icons = findobj(icons,'Type','Group');
icons(4).Children.MarkerSize = 20
icons(5).Children.MarkerSize = 20
icons(6).Children.MarkerSize = 20
% legend box off

% icons = findobj(icons,'Type','Group');
% Find lines that use a marker
% icons = findobj(icons,'Marker','none','-xor');
% Resize the marker in the legend
% set(icons,'MarkerSize',20);
% legend box off
% leg2.Title.String= 'sadssa'
% leg
leg2.Box = 'off'


