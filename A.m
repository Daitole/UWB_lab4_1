%% UWB lab 4 - indoor tracking with 4 PulsOn 410 units
clear all;
close all;

% Positions of the 4 units in meters
P101 = [-1.35,2];           
P102 = [-1.32,-1.5];        
P104 = [1.73,2];        
P106 = [1.90,-1.54];    

figure;
hold on; grid
plot(P101(1),P101(2),'ok','markerfacecolor','k');text(P101(1)+.1,P101(2),'101')
plot(P102(1),P102(2),'ok','markerfacecolor','k');text(P102(1)+.1,P102(2),'102')
plot(P104(1),P104(2),'ok','markerfacecolor','k');text(P104(1)+.1,P104(2),'104')
plot(P106(1),P106(2),'ok','markerfacecolor','k');text(P106(1)+.1,P106(2),'106')
    
plot(-1,1,'xr');text(-1.2,1.2,'A')
plot(0,1,'xr');text(.2,1.2,'B')
plot(1,1,'xr');text(1.2,1.2,'C')
plot(-1,0,'xr');text(-1.2,0.2,'D')
plot(0,0,'xr');text(.2,0.2,'E')
plot(1,0,'xr');text(1.2,0.2,'F')
plot(-1,-1,'xr');text(-1.2,-1.2,'G')
plot(0,-1,'xr');text(.2,-1.2,'H')
plot(1,-1,'xr');text(1.2,-1.2,'I')

axis image
title('GEOMETRY');xlabel('X (m)');ylabel('Y (m)')


%% ------------------------ Time zero calibration -------------------------
% !!!!!!!!!! NOT ESSENTIAL !!!!!!!!!!!!!
% Sphere placed at (0,0)%
% Loading data for t0 cal
%cd('Q:\UWB LAB Tracking\P');
% Load data from unit 103
[config,control,scans] = readMrmRetLog('101_Sphere00002.csv');
Nscans103 = length(scans);
tstmp103 = [scans.T];
data103 = [scans.scn];
data103 = reshape(data103,[],Nscans103);
% Load data from unit 104
[config,control,scans] = readMrmRetLog('102_Sphere00004.csv');
Nscans104 = length(scans);
tstmp104 = [scans.T];
data104 = [scans.scn];
data104 = reshape(data104,[],Nscans104);
% Load data from unit 105
[config,control,scans] = readMrmRetLog('104_Sphere00003.csv');
Nscans105 = length(scans);
tstmp105 = [scans.T];
data105 = [scans.scn];
data105 = reshape(data105,[],Nscans105);
% Load data from unit 106
[config,control,scans] = readMrmRetLog('106_Sphere00005.csv');
Nscans106 = length(scans);
tstmp106 = [scans.T];
data106 = [scans.scn];
data106 = reshape(data106,[],Nscans106);

% Load Sphere backgrounds

[config,control,scans] = readMrmRetLog('101_Sphere00BG003.csv');
BGNscans103 = length(scans);
BGtstmp103 = [scans.T];
BGdata103 = [scans.scn];
BGdata103 = reshape(BGdata103,[],BGNscans103);
% Load data from unit 104
[config,control,scans] = readMrmRetLog('102_Sphere00BG005.csv');
BGNscans104 = length(scans);
BGtstmp104 = [scans.T];
BGdata104 = [scans.scn];
BGdata104 = reshape(BGdata104,[],BGNscans104);
% Load data from unit 105
[config,control,scans] = readMrmRetLog('104_Sphere00BG004.csv');
BGNscans105 = length(scans);
BGtstmp105 = [scans.T];
BGdata105 = [scans.scn];
BGdata105 = reshape(BGdata105,[],BGNscans105);
% Load data from unit 106
[config,control,scans] = readMrmRetLog('106_Sphere00BG006.csv');
BGNscans106 = length(scans);
BGtstmp106 = [scans.T];
BGdata106 = [scans.scn];
BGdata106 = reshape(BGdata106,[],BGNscans106);

% fast time / range uncalibrated
t = linspace(scans(1).Tstrt,scans(1).Tstp,scans(1).Nscn)/1000;   % ns
rng = 3e8*(t-t(1))/2e9; % m

% 103
figure;imagesc(abs(data103));title('103')
%BG103 = repmat(mean(data103(:,50:110),2),1,Nscans103);
BG103 = repmat(mean(BGdata103,2),1,Nscans103);
data103bg = data103 - BG103;
figure;imagesc(abs(data103bg(200:400,:)));title('103')

rngSph103 = rng(230); % range of sphere in unit 103 (m)
rngSph103Real = norm(P103); % real range from unit 103 (m)
rngOffset103 = rngSph103Real - rngSph103; % range offset for unit 103

% 104
figure;imagesc(abs(data104));title('104')
%BG104 = repmat(mean(data104(:,50:110),2),1,Nscans104);
BG104 = repmat(mean(BGdata104,2),1,Nscans104);
data104bg = data104 - BG104;
figure;imagesc(abs(data104bg));title('104')

rngSph104 = rng(317); % range of sphere in unit 104 (m)
rngSph104Real = norm(P104); % real range from unit 104 (m)
rngOffset104 = rngSph104Real - rngSph104; % range offset for unit 104

% 105
figure;imagesc(abs(data105));title('105')
%BG105 = repmat(mean(data105(:,50:110),2),1,Nscans105);
BG105 = repmat(mean(BGdata105,2),1,Nscans105);
data105bg = data105 - BG105;
figure;imagesc(abs(data105bg));title('105')

rngSph105 = rng(395); % range of sphere in unit 105 (m)
rngSph105Real = norm(P105); % real range from unit 105 (m)
rngOffset105 = rngSph105Real - rngSph105; % range offset for unit 105

% 106
figure;imagesc(abs(data105));title('106')
%BG106 = repmat(mean(data106(:,50:110),2),1,Nscans106);
BG106 = repmat(mean(BGdata106,2),1,Nscans106);
data106bg = data106 - BG106;
figure;imagesc(abs(data106bg));title('106')

rngSph106 = rng(345); % range of sphere in unit 106 (m)
rngSph106Real = norm(P106); % real range from unit 106 (m)
rngOffset106 = rngSph106Real - rngSph106; % range offset for unit 106


%% Loading Data for tracking
%cd('D:\EDUCATION\UWB - Q4\Tracking lab\Data');
% Load data from unit 101
[config,control,scans] = readMrmRetLog('B101009.csv');
Nscans101 = length(scans);
tstmp101 = [scans.T];
data101 = [scans.scn];
data101 = reshape(data101,[],Nscans101);
% Load data from unit 102
[config,control,scans] = readMrmRetLog('B102009.csv');
Nscans102 = length(scans);
tstmp102 = [scans.T];
data102 = [scans.scn];
data102 = reshape(data102,[],Nscans102);
% Load data from unit 104
[config,control,scans] = readMrmRetLog('B103009.csv');
Nscans104 = length(scans);
tstmp104 = [scans.T];
data104 = [scans.scn];
data104 = reshape(data104,[],Nscans104);
% Load data from unit 106
[config,control,scans] = readMrmRetLog('B104009.csv');
Nscans106 = length(scans);
tstmp106 = [scans.T];
data106 = [scans.scn];
data106 = reshape(data106,[],Nscans106);

%% Data alignment
TStampStart = max([tstmp101(1),tstmp102(1),tstmp104(1),tstmp106(1)]);
TStampStop = min([tstmp101(end),tstmp102(end),tstmp104(end),tstmp106(end)]);

t101start_i = find(tstmp101>=TStampStart,1,'first');
t101stop_i = find(tstmp101<=TStampStop,1,'last');

t102start_i = find(tstmp102>=TStampStart,1,'first');
t102stop_i = find(tstmp102<=TStampStop,1,'last');

t104start_i = find(tstmp104>=TStampStart,1,'first');
t104stop_i = find(tstmp104<=TStampStop,1,'last');

t106start_i = find(tstmp106>=TStampStart,1,'first');
t106stop_i = find(tstmp106<=TStampStop,1,'last');

data101_algnd = data101(:,t101start_i:t101stop_i);
data102_algnd = data102(:,t102start_i:t102stop_i);
data104_algnd = data104(:,t104start_i:t104stop_i);
data106_algnd = data106(:,t106start_i:t106stop_i);

[Nsamp,Nscans101] = size(data101_algnd);
[Nsamp,Nscans102] = size(data102_algnd);
[Nsamp,Nscans104] = size(data104_algnd);
[Nsamp,Nscans106] = size(data106_algnd);

figure;imagesc(abs(data101_algnd));title('101')
figure;imagesc(abs(data102_algnd));title('102')
figure;imagesc(abs(data104_algnd));title('104')
figure;imagesc(abs(data106_algnd));title('106')

%% Background removal
close all;
BGidx = 280:360;  % select the slow time indexes containing the background data
BG101 = mean(data101_algnd(:,BGidx),2);   
BG102 = mean(data102_algnd(:,BGidx),2);
BG104 = mean(data104_algnd(:,BGidx),2);
BG106 = mean(data106_algnd(:,BGidx),2);

data101_algnd_bg = data101_algnd - repmat(BG101,1,Nscans101); % remove background
data102_algnd_bg = data102_algnd - repmat(BG102,1,Nscans102);
data104_algnd_bg = data104_algnd - repmat(BG104,1,Nscans104);
data106_algnd_bg = data106_algnd - repmat(BG106,1,Nscans106);

figure;imagesc(abs(data101_algnd_bg));title('101')
figure;imagesc(abs(data102_algnd_bg));title('102')
figure;imagesc(abs(data104_algnd_bg));title('104')
figure;imagesc(abs(data106_algnd_bg));title('106')

Motionidx = 23:280;  % select the slow time indexes containing the trajectory data
path101 = data101_algnd_bg(:,Motionidx); 
path102 = data102_algnd_bg(:,Motionidx);
path104 = data104_algnd_bg(:,Motionidx);
path106 = data106_algnd_bg(:,Motionidx);

% normalisation
path101 = path101/max(abs(path101(:))); 
path102 = path102/max(abs(path102(:))); 
path104 = path104/max(abs(path104(:)));
path106 = path106/max(abs(path106(:)));

figure;imagesc(abs(path101));title('101')
figure;imagesc(abs(path102));title('102')
figure;imagesc(abs(path104));title('104')
figure;imagesc(abs(path106));title('106');
%% Motion filter FIR4 if backgound subtraction unsuccessful (needed for some trajectories)
Motionidx = 20:75;
w = [1 -.6 -.3 -.1];

path101 = filter(w,1,data101_algnd,[],2);
path102 = filter(w,1,data102_algnd,[],2);
path104 = filter(w,1,data104_algnd,[],2);
path106 = filter(w,1,data106_algnd,[],2);

% normalisation
path101 = path101(:,Motionidx)/max(max(abs(path101(:,Motionidx)))); 
path102 = path102(:,Motionidx)/max(max(abs(path102(:,Motionidx)))); 
path104 = path104(:,Motionidx)/max(max(abs(path104(:,Motionidx))));
path106 = path106(:,Motionidx)/max(max(abs(path106(:,Motionidx))));

figure;imagesc(abs(path101));title('101')
figure;imagesc(abs(path102));title('102')
figure;imagesc(abs(path104));title('104')
figure;imagesc(abs(path106));title('106');

%% Range estimation
% fast time / range uncalibrated
t = linspace(scans(1).Tstrt,scans(1).Tstp,scans(1).Nscn)/1000;   % ns
rng = 3e8*(t-t(1))/2e9; % m
[Nrng,Nscans] = size(path101);
t_slow = 0:.5:.5*(Nscans-1);

% 101

estimated_range=[];
for i1=1:Nscans % Long time
    i2 = 10; % Avoiding picking antenna coupling
    while abs(path101(i2,i1)) < 0.01 && i2 < Nrng-1    % threshold 0.06
        i2 = i2 + 1;
    end
    estimated_range(i1) = rng(i2);
end
figure;plot(estimated_range)
median_range101 = medfilt1(estimated_range,3);%+rngOffset103;
figure;imagesc(t_slow,rng,abs(path101));title('103')
hold
plot(t_slow,median_range101,'w')  % readjust the threshold and coupling index based on this plot

% 102
%close all;
estimated_range=[];
for i1=1:Nscans % Long time
    i2 = 50; % Avoiding picking antenna coupling
    while abs(path102(i2,i1)) < 0.02 && i2 < Nrng-2
        i2 = i2 + 1;
    end
    estimated_range(i1) = rng(i2);
end
figure;plot(estimated_range)
median_range102 = medfilt1(estimated_range,3);%+rngOffset104;
figure;imagesc(t_slow,rng,abs(path102));title('102')
hold
plot(t_slow,median_range102,'w')

% 104
%close all;
estimated_range=[];
for i1=1:Nscans % Long time
    i2 = 30; % Avoiding picking antenna coupling
    while abs(path104(i2,i1)) < 0.02 && i2 < Nrng-1
        i2 = i2 + 1;
    end
    estimated_range(i1) = rng(i2);
end
figure;plot(estimated_range)
median_range104 = medfilt1(estimated_range,3);%+rngOffset105;
figure;imagesc(t_slow,rng,abs(path104));title('104')
hold
plot(t_slow,median_range104,'w')

% 106
%close all;
estimated_range=[];
for i1=1:Nscans % Long time
    i2 = 50; % Avoiding picking antenna coupling
    while abs(path106(i2,i1)) < 0.04 && i2 < Nrng-1
        i2 = i2 + 1;
    end
    estimated_range(i1) = rng(i2);
end
figure;plot(estimated_range)
median_range106 = medfilt1(estimated_range,3);%+rngOffset106;
figure;imagesc(t_slow,rng,abs(path106));title('106')
hold
plot(t_slow,median_range106,'w')

%% Target localisation

for scani = 1:Nscans
    [a, b] = circcirc(P101(1),P101(2),median_range101(scani),P102(1),P102(2),median_range104(scani));
    x12(scani,:) = a;
    y12(scani,:) = b;
end
figure;plot(x12(:,1),y12(:,2));title('101 - 102');axis([-1.5 1.5 -1.5 1.5])   

for scani = 1:Nscans
    [a, b] = circcirc(P101(1),P101(2),median_range101(scani),P104(1),P104(2),median_range104(scani));
    x14(scani,:) = a;
    y14(scani,:) = b;
end
figure;plot(x14(:,1),y14(:,2));title('101 - 104');axis([-1.5 1.5 -1.5 1.5])    

for scani = 1:Nscans
    [a, b] = circcirc(P101(1),P101(2),median_range101(scani),P106(1),P106(2),median_range106(scani));
    x16(scani,:) = a;
    y16(scani,:) = b;
end
figure;plot(x16(:,1),y16(:,1));title('101 - 106');axis([-1.5 1.5 -1.5 1.5])  

for scani = 1:Nscans
    [a, b] = circcirc(P102(1),P102(2),median_range102(scani),P104(1),P104(2),median_range104(scani));
    x24(scani,:) = a;
    y24(scani,:) = b;
end
figure;plot(x24(:,2),y24(:,2));title('102 - 104');axis([-1.5 1.5 -1.5 1.5])  

for scani = 1:Nscans
    [a, b] = circcirc(P102(1),P102(2),median_range102(scani),P106(1),P106(2),median_range106(scani));
    x26(scani,:) = a;
    y26(scani,:) = b;
end
figure;plot(x26(:,2),y26(:,1));title('102 - 106');axis([-1.5 1.5 -1.5 1.5])  

for scani = 1:Nscans
    [a, b] = circcirc(P104(1),P104(2),median_range104(scani),P106(1),P106(2),median_range106(scani));
    x46(scani,:) = a;
    y46(scani,:) = b;
end
figure;plot(x46(:,2),y46(:,2));title('104 - 106');axis([-1.5 1.5 -1.5 1.5])  


%% FINAL PLOT
% x = nanmean([x14(:,1),x26(:,2),x46(:,2),x12(:,1)],2);
% y = nanmean([y14(:,2),y26(:,1),y46(:,2),y12(:,2)],2);
% 
x = nanmean([x46(:,2), x12(:,1)],2);
y = nanmean([y46(:,2), x12(:,1)],2);

figure;plot(smooth(x,3),smooth(y,3),'linewidth',2);axis([-2.5 2.5 -3 3]);grid
hold on
plot(P101(1),P101(2),'ok','markerfacecolor','k');text(P101(1)+.1,P101(2),'101')
plot(P102(1),P102(2),'ok','markerfacecolor','k');text(P102(1)+.1,P102(2),'102')
plot(P104(1),P104(2),'ok','markerfacecolor','k');text(P104(1)+.1,P104(2),'104')
plot(P106(1),P106(2),'ok','markerfacecolor','k');text(P106(1)+.1,P106(2),'106')
    
plot(-1,1,'xr');text(-1.2,1.2,'A')
plot(0,1,'xr');text(.2,1.2,'B')
plot(1,1,'xr');text(1.2,1.2,'C')
plot(-1,0,'xr');text(-1.2,0.2,'D')
plot(0,0,'xr');text(.2,0.2,'E')
plot(1,0,'xr');text(1.2,0.2,'F')
plot(-1,-1,'xr');text(-1.2,-1.2,'G')
plot(0,-1,'xr');text(.2,-1.2,'H')
plot(1,-1,'xr');text(1.2,-1.2,'I')

axis image
title('AEI trajectory');xlabel('X (m)');ylabel('Y (m)')

    