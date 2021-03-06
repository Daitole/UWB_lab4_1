%% UWB lab 4 - indoor tracking with 4 PulsOn 410 units
% Units positions in meters
clear;
close all;
P101 = [-1.5,-1.6];     
P102 = [-1.4,1.5];
P103 = [1.7,1.9];
P104 = [2.3,-1.3];

% Floor markers position in meters
A = [-1,1];
B = [0,1];
C = [1,1];
D = [-1,0];
E = [0,0];
F = [1,0];
G = [-1,-1];
H = [0,-1];
I = [1,-1];

MarkPos = [A;B;C;D;E;F;G;H;I];


%% ------------------------ Time zero calibration -------------------------
% Sphere placed at (0,0)%% Loading data for t0 cal

% Load data from unit 101
[config,control,scans] = readMrmRetLog('sphere101006.csv');
Nscans101 = length(scans);
tstmp101 = [scans.T];
data101 = [scans.scn];
data101 = reshape(data101,[],Nscans101);
% Load data from unit 102
[config,control,scans] = readMrmRetLog('sphere102006.csv');
Nscans102 = length(scans);
tstmp102 = [scans.T];
data102 = [scans.scn];
data102 = reshape(data102,[],Nscans102);

% Load data from unit 103
[config,control,scans] = readMrmRetLog('sphere103006.csv');
Nscans103 = length(scans);
tstmp103 = [scans.T];
data103 = [scans.scn];
data103 = reshape(data103,[],Nscans103);
% Load data from unit 104
[config,control,scans] = readMrmRetLog('sphere104006.csv');
Nscans104 = length(scans);
tstmp104 = [scans.T];
data104 = [scans.scn];
data104 = reshape(data104,[],Nscans104);

% SPHERE BCKGRND
% Load data from unit 101
[config,control,scans] = readMrmRetLog('BGsphere101007.csv');
bgNscans101 = length(scans);
bgtstmp101 = [scans.T];
bgdata101 = [scans.scn];
bgdata101 = reshape(bgdata101,[],bgNscans101);
% Load data from unit 102
[config,control,scans] = readMrmRetLog('BGsphere102007.csv');
bgNscans102 = length(scans);
bgtstmp102 = [scans.T];
bgdata102 = [scans.scn];
bgdata102 = reshape(bgdata102,[],bgNscans102);

% Load data from unit 103
[config,control,scans] = readMrmRetLog('BGsphere103007.csv');
bgNscans103 = length(scans);
bgtstmp103 = [scans.T];
bgdata103 = [scans.scn];
bgdata103 = reshape(bgdata103,[],bgNscans103);
% Load data from unit 104
[config,control,scans] = readMrmRetLog('BGsphere104007.csv');
bgNscans104 = length(scans);
bgtstmp104 = [scans.T];
bgdata104 = [scans.scn];
bgdata104 = reshape(bgdata104,[],bgNscans104);

% fast time / range uncalibrated
t = linspace(scans(1).Tstrt,scans(1).Tstp,scans(1).Nscn)/1000;   % ns
rng = 3e8*(t-t(1))/2e9; % m

% 101
figure;imagesc(abs(data101));title('101')
figure;imagesc(bgdata101);
BG101 = repmat(mean(bgdata101(:,:),2),1,Nscans101);
data101bg = data101 - BG101;
figure;imagesc(abs(data101bg));title('101')

rngSph101 = rng(153); % range of sphere in unit 105 (m)
rngSph101Real = norm(P101); % real range from unit 105 (m)
rngOffset101 = rngSph101Real - rngSph101; % range offset for unit 101

% 102
figure;imagesc(abs(data102));title('102')
BG102 = repmat(mean(bgdata102(:,:),2),1,Nscans102);
data102bg = data102 - BG102;
figure;imagesc(abs(data102bg));title('102')

rngSph102 = rng(150); % range of sphere in unit 106 (m)
rngSph102Real = norm(P102); % real range from unit 106 (m)
rngOffset102 = rngSph102Real - rngSph102; % range offset for unit 106

% 103
figure;imagesc(abs(data103));title('103')
BG103 = repmat(mean(bgdata103,2),1,Nscans103);
data103bg = data103 - BG103;
figure;imagesc(abs(data103bg));title('103')

rngSph103 = rng(126); % range of sphere in unit 103 (m)
rngSph103Real = norm(P103); % real range from unit 103 (m)
rngOffset103 = rngSph103Real - rngSph103; % range offset for unit 103

% 104
figure;imagesc(abs(data104));title('104')
figure;imagesc(bgdata104)
BG104 = repmat(mean(bgdata104(:,:),2),1,Nscans104);
data104bg = data104 - BG104;
figure;imagesc(abs(data104bg));title('104')

rngSph104 = rng(200); % range of sphere in unit 104 (m)
rngSph104Real = norm(P104); % real range from unit 104 (m)
rngOffset104 = rngSph104Real - rngSph104; % range offset for unit 104


%% Loading Data for tracking

% Load data from unit 101
[config,control,scans] = readMrmRetLog('A101008.csv');
Nscans101 = length(scans);
tstmp101 = [scans.T];
data101 = [scans.scn];
data101 = reshape(data101,[],Nscans101);
% Load data from unit 102
[config,control,scans] = readMrmRetLog('A102008.csv');
Nscans102 = length(scans);
tstmp102 = [scans.T];
data102 = [scans.scn];
data102 = reshape(data102,[],Nscans102);
% Load data from unit 103
[config,control,scans] = readMrmRetLog('A103008.csv');
Nscans103 = length(scans);
tstmp103 = [scans.T];
data103 = [scans.scn];
data103 = reshape(data103,[],Nscans103);
% Load data from unit 104
[config,control,scans] = readMrmRetLog('A104008.csv');
Nscans104 = length(scans);
tstmp104 = [scans.T];
data104 = [scans.scn];
data104 = reshape(data104,[],Nscans104);

%% Data alignment
TStampStart = max([tstmp101(1),tstmp102(1),tstmp103(1),tstmp104(1)]);
TStampStop = min([tstmp101(end),tstmp102(end),tstmp103(end),tstmp104(end)]);

t101start_i = find(tstmp101>=TStampStart,1,'first');
t101stop_i = find(tstmp101<=TStampStop,1,'last');

t102start_i = find(tstmp102>=TStampStart,1,'first');
t102stop_i = find(tstmp102<=TStampStop,1,'last');

t103start_i = find(tstmp103>=TStampStart,1,'first');
t103stop_i = find(tstmp103<=TStampStop,1,'last');

t104start_i = find(tstmp104>=TStampStart,1,'first');
t104stop_i = find(tstmp104<=TStampStop,1,'last');

data101_algnd = data101(:,t101start_i:t101stop_i);
data102_algnd = data102(:,t102start_i:t102stop_i);
data103_algnd = data103(:,t103start_i:t103stop_i);
data104_algnd = data104(:,t104start_i:t104stop_i);

[Nsamp,Nscans] = size(data101_algnd);

figure;imagesc(abs(data101_algnd)); colorbar;

xlabel('Slow time(S)', 'FontSize', 12, 'FontWeight', 'bold');
ylabel('Fast time(nS)', 'FontSize', 12, 'FontWeight', 'bold');
title(['Slow time fast time plot for radar 101 before background subtraction'], ...
    'FontSize', 12, 'FontWeight', 'bold');
print('b_bg_S_01_S', '-depsc');
%legend({'|S_{11}|^2 TE', '|S_{11}|^2 TM', '|S_{12}|^2 TE', '|S_{12}|^2 TM'},...
    %'Location','south', 'FontSize', 12, 'FontWeight', 'bold');

figure;imagesc(abs(data102_algnd)); colorbar;

xlabel('Slow time(S)', 'FontSize', 12, 'FontWeight', 'bold');
ylabel('Fast time(nS)', 'FontSize', 12, 'FontWeight', 'bold');
title(['Slow time fast time plot for radar 102 before background subtraction'], ...
    'FontSize', 12, 'FontWeight', 'bold');
print('b_bg_S_02_S', '-depsc');

figure;imagesc(abs(data103_algnd)); colorbar;
xlabel('Slow time(S)', 'FontSize', 12, 'FontWeight', 'bold');
ylabel('Fast time(nS)', 'FontSize', 12, 'FontWeight', 'bold');
title(['Slow time fast time plot for radar 103 before background subtraction'], ...
    'FontSize', 12, 'FontWeight', 'bold');
print('b_bg_S_03_S', '-depsc');

figure;imagesc(abs(data104_algnd)); colorbar;
xlabel('Slow time(S)', 'FontSize', 12, 'FontWeight', 'bold');
ylabel('Fast time(nS)', 'FontSize', 12, 'FontWeight', 'bold');
title(['Slow time fast time plot for radar 104 before background subtraction'], ...
    'FontSize', 12, 'FontWeight', 'bold');
print('b_bg_S_04_S', '-depsc');


%% Background removal
BGidx = 110:130;
BG101 = mean(data101_algnd(:,BGidx),2); % select the slow time indexes containing the background data (here 170:230)
BG102 = mean(data102_algnd(:,BGidx),2);
BG103 = mean(data103_algnd(:,BGidx),2);   
BG104 = mean(data104_algnd(:,BGidx),2);


data101_algnd_bg = data101_algnd - repmat(BG101,1,size(data101_algnd,2));
data102_algnd_bg = data102_algnd - repmat(BG102,1,size(data102_algnd,2));  
data103_algnd_bg = data103_algnd - repmat(BG103,1,size(data103_algnd,2)); % remove background
data104_algnd_bg = data104_algnd - repmat(BG104,1,size(data104_algnd,2));


figure;imagesc(abs(data101_algnd_bg));colorbar;

xlabel('Slow time(S)', 'FontSize', 12, 'FontWeight', 'bold');
ylabel('Fast time(nS)', 'FontSize', 12, 'FontWeight', 'bold');
title(['Slow time fast time plot for radar 101 after background subtraction'], ...
    'FontSize', 12, 'FontWeight', 'bold');
print('bg_S_01_S', '-depsc');

figure;imagesc(abs(data102_algnd_bg));colorbar;
xlabel('Slow time(S)', 'FontSize', 12, 'FontWeight', 'bold');
ylabel('Fast time(nS)', 'FontSize', 12, 'FontWeight', 'bold');
title(['Slow time fast time plot for radar 102 after background subtraction'], ...
    'FontSize', 12, 'FontWeight', 'bold');
print('bg_S_02_S', '-depsc');

figure;imagesc(abs(data103_algnd_bg));colorbar;
xlabel('Slow time(S)', 'FontSize', 12, 'FontWeight', 'bold');
ylabel('Fast time(nS)', 'FontSize', 12, 'FontWeight', 'bold');
title(['Slow time fast time plot for radar 103 after background subtraction'], ...
    'FontSize', 12, 'FontWeight', 'bold');
print('bg_S_03_S', '-depsc');


figure;imagesc(abs(data104_algnd_bg));colorbar;

xlabel('Slow time(S)', 'FontSize', 12, 'FontWeight', 'bold');
ylabel('Fast time(nS)', 'FontSize', 12, 'FontWeight', 'bold');
title(['Slow time fast time plot for radar 104 after background subtraction'], ...
    'FontSize', 12, 'FontWeight', 'bold');
print('bg_S_04_S', '-depsc');

Motionidx = 25:95;
path101 = data101_algnd_bg(:,Motionidx);
path102 = data102_algnd_bg(:,Motionidx);
path103 = data103_algnd_bg(:,Motionidx); % select the slow time indexes containing the trajectory data (here 15:115)
path104 = data104_algnd_bg(:,Motionidx);


path101 = path101/max(abs(path101(:)));
path102 = path102/max(abs(path102(:)));
path103 = path103/max(abs(path103(:))); % normalisation
path104 = path104/max(abs(path104(:))); 


figure;imagesc(abs(path101)); colorbar;
xlabel('Slow time(S)', 'FontSize', 12, 'FontWeight', 'bold');
ylabel('Fast time(nS)', 'FontSize', 12, 'FontWeight', 'bold');
title(['Slow time fast time plot - Slowtime of interest (Target in motion) radar 101'], ...
    'FontSize', 12, 'FontWeight', 'bold');
print('bg_S_01_1_S', '-depsc');

figure;imagesc(abs(path102)); colorbar;
xlabel('Slow time(S)', 'FontSize', 12, 'FontWeight', 'bold');
ylabel('Fast time(nS)', 'FontSize', 12, 'FontWeight', 'bold');
title(['Slow time fast time plot - Slowtime of interest (Target in motion) radar 102'], ...
    'FontSize', 12, 'FontWeight', 'bold');
print('bg_S_02_1_S', '-depsc');

figure;imagesc(abs(path103)); colorbar;

xlabel('Slow time(S)', 'FontSize', 12, 'FontWeight', 'bold');
ylabel('Fast time(nS)', 'FontSize', 12, 'FontWeight', 'bold');
title(['Slow time fast time plot - Slowtime of interest (Target in motion) radar 103'], ...
    'FontSize', 12, 'FontWeight', 'bold');
print('bg_S_03_1_S', '-depsc');

figure;imagesc(abs(path104)); colorbar;

xlabel('Slow time(S)', 'FontSize', 12, 'FontWeight', 'bold');
ylabel('Fast time(nS)', 'FontSize', 12, 'FontWeight', 'bold');
title(['Slow time fast time plot - Slowtime of interest (Target in motion) radar 104'], ...
    'FontSize', 12, 'FontWeight', 'bold');
print('bg_S_04_1_S', '-depsc');


%% Bandpass filter
b = [0.058918593549 0.003704122993 -0.130605206968 0 0.130605206968 -0.003704122993 -0.058918593549];
a = [1 0.339893240317 1.247471159638 0.315004577848 0.752494992039 0.094346011045 0.145214408359];

path105BPF = filter(b,a,path105);

%% Motion filter FIR4 if backgound subtraction unsuccessful
w = [1 -.6 -.3 -.1];

path104mti = filter(w,1,path104,[],2);
path105 = filter(w,1,path105BPF,[],2);

%% Range estimation
[Nrng,Nscans] = size(path103);
t_slow = 0:.5:.5*(Nscans-1);

% 101
for i1=1:Nscans % Long time
    i2 = 80; % Avoiding picking antenna coupling
    while abs(path101(i2,i1)) < 0.045 && i2 < Nrng-1
        i2 = i2 + 1;
    end
    estimated_range(i1) = rng(i2);
end
figure;plot(t_slow, estimated_range, 'LineWidth', 2);grid on;
xlabel('Slow time(S)', 'FontSize', 12, 'FontWeight', 'bold');
ylabel('Range(m)', 'FontSize', 12, 'FontWeight', 'bold');
title(['Target motion in slow time'], ...
    'FontSize', 12, 'FontWeight', 'bold');
print('Motion_101_S', '-depsc');

median_range101 = medfilt1(estimated_range,6);%+rngOffset101;
figure;imagesc(t_slow,rng,abs(path101));
hold
plot(t_slow,median_range101,'w', 'LineWidth', 2);

xlabel('Slow time(S)', 'FontSize', 12, 'FontWeight', 'bold');
ylabel('Range(m)', 'FontSize', 12, 'FontWeight', 'bold');
title(['Target motion in slow time with the range slowtime plot'], ...
    'FontSize', 12, 'FontWeight', 'bold');
print('RD_101_S', '-depsc');

%plot(t_slow,estimated_range,'y')


% 102
for i1=1:Nscans % Long time
    i2 = 80; % Avoiding picking antenna coupling
    while abs(path102(i2,i1)) < 0.03 && i2 < Nrng-1
        i2 = i2 + 1;
    end
    estimated_range(i1) = rng(i2);
end
figure;plot(t_slow, estimated_range, 'LineWidth', 2);grid on;
xlabel('Slow time(S)', 'FontSize', 12, 'FontWeight', 'bold');
ylabel('Range(m)', 'FontSize', 12, 'FontWeight', 'bold');
title(['Target motion in slow time'], ...
    'FontSize', 12, 'FontWeight', 'bold');
print('Motion_102_S', '-depsc');

median_range102 = medfilt1(estimated_range,6);%+rngOffset102;
figure;imagesc(t_slow,rng,abs(path102));
hold
plot(t_slow,median_range102,'w', 'LineWidth', 2);

xlabel('Slow time(S)', 'FontSize', 12, 'FontWeight', 'bold');
ylabel('Range(m)', 'FontSize', 12, 'FontWeight', 'bold');
title(['Target motion in slow time with the range slowtime plot'], ...
    'FontSize', 12, 'FontWeight', 'bold');
print('RD_102_S', '-depsc');

% 103
for i1=1:Nscans % Long time
    i2 = 80; % Avoiding picking antenna coupling
    while abs(path103(i2,i1)) < 0.045 && i2 < Nrng-1    % threshold 0.125
        i2 = i2 + 1;
    end
    estimated_range(i1) = rng(i2);
end
figure;plot(t_slow, estimated_range, 'LineWidth', 2); grid on;
xlabel('Slow time(S)', 'FontSize', 12, 'FontWeight', 'bold');
ylabel('Range(m)', 'FontSize', 12, 'FontWeight', 'bold');
title(['Target motion in slow time'], ...
    'FontSize', 12, 'FontWeight', 'bold');
print('Motion_103_S', '-depsc');

median_range103 = medfilt1(estimated_range,6);%+rngOffset103; % !!!!! test median filter 6 instead of 3
figure;imagesc(t_slow,rng,abs(path103));
hold
plot(t_slow,median_range103,'w', 'LineWidth', 2); 

xlabel('Slow time(S)', 'FontSize', 12, 'FontWeight', 'bold');
ylabel('Range(m)', 'FontSize', 12, 'FontWeight', 'bold');
title(['Target motion in slow time with the range slowtime plot'], ...
    'FontSize', 12, 'FontWeight', 'bold');
print('RD_103_S', '-depsc');  % readjust the threshold and coupling index based on this plot

% 104
for i1=1:Nscans % Long time
    i2 = 80; % Avoiding picking antenna coupling
    while abs(path104(i2,i1)) < 0.06 && i2 < Nrng-1
        i2 = i2 + 1;
    end
    estimated_range(i1) = rng(i2);
end
figure;plot(t_slow, estimated_range, 'LineWidth', 2); grid on;
xlabel('Slow time(S)', 'FontSize', 12, 'FontWeight', 'bold');
ylabel('Range(m)', 'FontSize', 12, 'FontWeight', 'bold');
title(['Target motion in slow time'], ...
    'FontSize', 12, 'FontWeight', 'bold');
print('Motion_104_S', '-depsc');

median_range104 = medfilt1(estimated_range,6);%+rngOffset104;
figure;imagesc(t_slow,rng,abs(path104));
hold
plot(t_slow,median_range104,'w', 'LineWidth', 2);

xlabel('Slow time(S)', 'FontSize', 12, 'FontWeight', 'bold');
ylabel('Range(m)', 'FontSize', 12, 'FontWeight', 'bold');
title(['Target motion in slow time with the range slowtime plot'], ...
    'FontSize', 12, 'FontWeight', 'bold');
print('RD_104_S', '-depsc');

%% CFAR detection:
[Nrng,Nscans] = size(path103);
t_slow = 0:.5:.5*(Nscans-1);
Nsamp_to_measure = size(path103(rng < 2.5), 2);

% data from radar 1
for k = 1:Nscans

    [Ind(k), th(1:Nsamp_to_measure, k)] = CFAR(path101(1:Nsamp_to_measure, k), 21, 0.08, 16);
    est_rng(k) = rng(Ind(k));
end

figure;imagesc(t_slow,rng,abs(path101));title('101')
hold on;
med101 = medfilt1(est_rng, 6);
plot(t_slow, med101, 'w')
figure;
plot(rng(1:Nsamp_to_measure), path101(1:Nsamp_to_measure, 7), 'LineWidth', 2)
hold on;
plot(rng(1:Nsamp_to_measure), th(1:Nsamp_to_measure, 7), 'LineWidth', 2)

figure;
plot(rng(1:Nsamp_to_measure), path101(1:Nsamp_to_measure, 50), 'LineWidth', 2)
hold on;
plot(rng(1:Nsamp_to_measure), th(1:Nsamp_to_measure, 50), 'LineWidth', 2)

% for data from radar 2
for k = 1:Nscans

    [Ind(k), th(1:Nsamp_to_measure, k)] = CFAR(path102(1:Nsamp_to_measure, k), 21, 0.08, 16);
    est_rng(k) = rng(Ind(k));
end

figure;imagesc(t_slow,rng,abs(path102));title('102')
hold on;
med102 = medfilt1(est_rng, 6);
plot(t_slow, med102, 'w')
figure;
plot(rng(1:Nsamp_to_measure), path102(1:Nsamp_to_measure, 7), 'LineWidth', 2)
hold on;
plot(rng(1:Nsamp_to_measure), th(1:Nsamp_to_measure, 7), 'LineWidth', 2)

figure;
plot(rng(1:Nsamp_to_measure), path102(1:Nsamp_to_measure, 50), 'LineWidth', 2)
hold on;
plot(rng(1:Nsamp_to_measure), th(1:Nsamp_to_measure, 50), 'LineWidth', 2)

% data from radar 3
Nsamp_to_measure = size(path103(rng < 3), 2);

for k = 1:Nscans

    [Ind(k), th(1:Nsamp_to_measure, k)] = CFAR(path103(1:Nsamp_to_measure, k), 21, 0.08, 16);
    est_rng(k) = rng(Ind(k));
end

figure;imagesc(t_slow,rng,abs(path103));title('103')
hold on;
med103 = medfilt1(est_rng, 6);
plot(t_slow, med103, 'w')
figure;
plot(rng(1:Nsamp_to_measure), path103(1:Nsamp_to_measure, 7), 'LineWidth', 2)
hold on;
plot(rng(1:Nsamp_to_measure), th(1:Nsamp_to_measure, 7), 'LineWidth', 2)

figure;
plot(rng(1:Nsamp_to_measure), path103(1:Nsamp_to_measure, 50), 'LineWidth', 2)
hold on;
plot(rng(1:Nsamp_to_measure), th(1:Nsamp_to_measure, 50), 'LineWidth', 2)

% data from radar 4

%Nsamp_to_measure = size(path104(rng < 3), 2);

for k = 1:Nscans

    [Ind(k), th(1:Nsamp_to_measure, k)] = CFAR(path104(1:Nsamp_to_measure, k), 21, 0.1, 16);
    est_rng(k) = rng(Ind(k));
end

figure;imagesc(t_slow,rng,abs(path104));title('104')
hold on;
med104 = medfilt1(est_rng, 6);
plot(t_slow, med104, 'w')
figure;
plot(rng(1:Nsamp_to_measure), path104(1:Nsamp_to_measure, 7), 'LineWidth', 2)
hold on;
plot(rng(1:Nsamp_to_measure), th(1:Nsamp_to_measure, 7), 'LineWidth', 2)

figure;
plot(rng(1:Nsamp_to_measure), path104(1:Nsamp_to_measure, 50), 'LineWidth', 2)
hold on;
plot(rng(1:Nsamp_to_measure), th(1:Nsamp_to_measure, 50), 'LineWidth', 2)


% plot(rng, path101(:, 4), 'LineWidth', 2);
% hold on;
% plot(rng, 0.1 + th(:, 4), 'LineWidth', 2);



%% Target localisation
% 101 - 102
for scani = 1:Nscans
    [a, b] = circcirc(P101(1),P101(2),median_range101(scani),P102(1),P102(2),median_range102(scani));
    x12(scani,:) = a;
    y12(scani,:) = b;

end
figure;plot(x12(:,2),y12(:,2),'o-');title('101 - 102')   

% 101 - 103
for scani = 1:Nscans
    [a, b] = circcirc(P101(1),P101(2),median_range101(scani),P103(1),P103(2),median_range103(scani));
    x13(scani,:) = a;
    y13(scani,:) = b;
end
figure;plot(x13(:,2),y13(:,2));title('101 - 103')  

% 101 - 104
for scani = 1:Nscans
    [a, b] = circcirc(P101(1),P101(2),median_range101(scani),P104(1),P104(2),median_range104(scani));
    x14(scani,:) = a;
    y14(scani,:) = b;
end
figure;plot(x14(:,1),y14(:,1));title('101 - 104')

% 102 - 103
for scani = 1:Nscans
    [a, b] = circcirc(P102(1),P102(2),median_range102(scani),P103(1),P103(2),median_range103(scani));
    x23(scani,:) = a;
    y23(scani,:) = b;
end
figure;plot(x23(:,2),y23(:,2));title('102 - 103') % select coordinates inside the area delimited by the units

% 102 - 104
for scani = 1:Nscans
    [a, b] = circcirc(P102(1),P102(2),median_range102(scani),P104(1),P104(2),median_range104(scani));
    x24(scani,:) = a;
    y24(scani,:) = b;
end
figure;plot(x24(:,2),y24(:,1));title('102 - 104')

% 103 - 104
for scani = 1:Nscans
    [a, b] = circcirc(P103(1),P103(2),median_range103(scani),P104(1),P104(2),median_range104(scani));
    x34(scani,:) = a;
    y34(scani,:) = b;
end
figure;plot(x34(:,2),y34(:,2));title('103 - 104')

%%
x = nanmean([x34(:,1), x14(:,2)],2);
y = nanmean([y34(:,1), y14(:,2)],2);

figure;plot(smooth(x,3),smooth(y,3),'x-','linewidth',2);axis([-3 3 -3 3]);grid
axis square
hold on
plot(P101(1),P101(2),'ok','markerfacecolor','k');text(P101(1)+.1,P101(2),'101')
plot(P102(1),P102(2),'ok','markerfacecolor','k');text(P102(1)+.1,P102(2),'102')
plot(P103(1),P103(2),'ok','markerfacecolor','k');text(P103(1)+.1,P103(2),'103')
plot(P104(1),P104(2),'ok','markerfacecolor','k');text(P104(1)+.1,P104(2),'104')
    
text(MarkPos(1,1),MarkPos(1,2),'A')
text(MarkPos(2,1),MarkPos(2,2),'B')
text(MarkPos(3,1),MarkPos(3,2),'C')
text(MarkPos(4,1),MarkPos(4,2),'D')
text(MarkPos(5,1),MarkPos(5,2),'E')
text(MarkPos(6,1),MarkPos(6,2),'F')
text(MarkPos(7,1),MarkPos(7,2),'G')
text(MarkPos(8,1),MarkPos(8,2),'H')
text(MarkPos(9,1),MarkPos(9,2),'I')

set(gca,'PlotBoxAspectRatio',[1 1 1])
title('BCFEB trajectory');xlabel('X (m)');ylabel('Y (m)')




%% Check speed threshold

% 105
estimated_range = zeros(Nscans,1);

i2 = 220; % Avoiding picking antenna coupling
while abs(path105(i2,1)) < 0.17 && i2 < Nrng-1
        i2 = i2 + 1;
end
estimated_range(1) = rng(i2);

for i1=2:Nscans % Slow time
    i2 = 220; % Avoiding picking antenna coupling
    while i2 < Nrng-1
        i2 = i2 + 1;
        if abs(path105(i2,i1)) > 0.19
            rngtmp = rng(i2);
            if abs(rngtmp-estimated_range(i1-1)) < .2
                estimated_range(i1) = rng(i2);
                break
            end
        end
        estimated_range(i1) = estimated_range(i1-1);
    end
 end

median_range105 = medfilt1(estimated_range,6)+rngOffset105;
figure;imagesc(t_slow,rng,abs(path105));title('105')
hold
plot(t_slow,median_range105,'w')
plot(t_slow,estimated_range,'y')

%% Least Square method:
Theta_x = zeros(1, Nscans);
Theta_y = zeros(1, Nscans);

    x1 = P101(1);
    x2 = P102(1);
    x3 = P103(1);
    x4 = P104(1);
    
    y1 = P101(2);
    y2 = P102(2);
    y3 = P103(2);
    y4 = P104(2);

for i = 1:Nscans
    
%     r1 = median_range101(i);
%     r2 = median_range102(i);
%     r3 = median_range103(i);
%     r4 = median_range104(i);
    
    r1 = med101(i);
    r2 = med102(i);
    r3 = med103(i);
    r4 = med104(i);
    
    
    
    X = [r1^2 - r4^2 - x1^2 + x4^2 - y1^2 + y4^2; r2^2 - r4^2 - x2^2 + x4^2 - y2^2 + y4^2; ... 
        r3^2 - r4^2 - x3^2 + x4^2 - y3^2 + y4^2];
    
    H = 2.* [(x4 - x1) (y4 - y1);  (x4 - x2) (y4 - y2); (x4 - x3) (y4 - y3)];   
    
    Theta = inv(H'*H) * H' * X;
    Theta_x(i) = Theta(1);
    Theta_y(i) = Theta(2);
    
    
    
%     U = inv(H)*X;
%     U_x = U(1);
%     U_y = U(2);
%     
    
    
end

figure;plot(smooth(Theta_x,3),smooth(Theta_y,3),'x-','linewidth',2, ...
    'color', [0.6350, 0.0780, 0.1840]);axis([-3 3 -3 3]);grid
axis square
hold on
% plot(smooth(U_x,3),smooth(U_y,3),'x-','linewidth',2);axis([-3 3 -3 3]);grid
figure;
hold on;
grid on;

plot(P101(1),P101(2),'ok','markerfacecolor','k');text(P101(1)+.1,P101(2),'101 (-1.5, -1.6)')
plot(P102(1),P102(2),'ok','markerfacecolor','k');text(P102(1)+.1,P102(2),'102 (-1.4, 1.5)')
plot(P103(1),P103(2),'ok','markerfacecolor','k');text(P103(1)+.1,P103(2),'103 (1.7, 1.9)')
plot(P104(1),P104(2),'ok','markerfacecolor','k');text(P104(1)+.1,P104(2),'104 (2.3, -1.3)')
    
text(MarkPos(1,1),MarkPos(1,2),'A')
text(MarkPos(2,1),MarkPos(2,2),'B')
text(MarkPos(3,1),MarkPos(3,2),'C')
text(MarkPos(4,1),MarkPos(4,2),'D')
text(MarkPos(5,1),MarkPos(5,2),'E')
text(MarkPos(6,1),MarkPos(6,2),'F')
text(MarkPos(7,1),MarkPos(7,2),'G')
text(MarkPos(8,1),MarkPos(8,2),'H')
text(MarkPos(9,1),MarkPos(9,2),'I')

set(gca,'PlotBoxAspectRatio',[1 1 1])
title('EH trajectory with CA CFAR detection');xlabel('X (m)');ylabel('Y (m)')