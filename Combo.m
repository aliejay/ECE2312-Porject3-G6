% Project 3

Fs = 44100;
f = 5000; 

w0 = 2*pi*f;
duration = 5;

n = 0:(1/Fs):duration;
amp = 1;

y = amp*sin(w0*n);

file1 = 'team[6]-stereosoundfile.wav';
[arr, Fs] = audioread(file1);
audioinfo(file1);

info = audiodevinfo;
info.input(1)
info.input(2)

nBits = 8;
nChannels = 1;

recorder = audiorecorder(Fs, nBits, nChannels, 1);


target_F = 8000;
sampling_freq = 44100;

factor = cast((sampling_freq/target_F), "uint8");
stopband_st = target_F/sampling_freq;
passband_end = (target_F-2000)/sampling_freq;

highpassband = target_F/10;
disp(highpassband)

F = [0 passband_end stopband_st 1];
A = [1 1 0 0];

lpf = firls(255, F, A);

FL = [0 passband_end/2 stopband_st/2 1];
llpf = firls(255, FL, A);

LHpassband = highpassband/4;
disp(LHpassband)

FH = [0 passband_end*1.5 stopband_st*1.5 1];
hlpf = firls(255, FH, A);

HHpassband = highpassband/1.5;

lowfiltered = filter(lpf, A, arr);
highfiltered = highpass(arr, highpassband, target_F);

lowlowfiltered = filter(llpf, A, lowfiltered);
lowhighfiltered = highpass(lowfiltered, LHpassband, target_F/2);
highlowfiltered = filter(hlpf, A, highfiltered);
highhighfiltered = highpass(highfiltered, HHpassband, target_F/2);

lowlowcleaned = downsample(lowlowfiltered, factor);
lowhighcleaned = downsample(lowhighfiltered, factor);
highlowcleaned = downsample(highlowfiltered, factor);
highhighcleaned = downsample(highhighfiltered, factor);

combo = lowlowcleaned + lowhighcleaned + highlowcleaned + highhighcleaned;

pause(1);
disp("Get Ready")
pause(1);

disp("3")
pause(1);

disp("2")
pause(1);

disp("1")
pause(1);

disp("Record")

record(recorder, duration);
sound(combo, target_F)

% Wait 5 seconds
pause(duration);
disp("Recording over")

arr1 = getaudiodata(recorder, "double");


clf
% Spectrogram LowLowpass
figure;
subplot(4, 1, 4);
window = hamming(512);
N_overlap = 256;
N_fft = 1024;
[S1, F1, T1, P1] = spectrogram(lowlowcleaned, window, N_overlap, N_fft,target_F, 'yaxis');
surf(T1, F1, 10*log10(P1), 'edgecolor', 'none');
axis tight;
view(0,90);
colormap(jet);
set(gca,'clim', [-80 -20]);
title('Low Low Pass');
ylim([0 2000]);
xlabel('Time (s)');
ylabel('Frequency (Hz)');

% Spectrogram LowHighpass
subplot(4, 1, 3);
window = hamming(512);
N_overlap = 256;
N_fft = 1024;
[S2, F2, T2, P2] = spectrogram(lowhighcleaned, window, N_overlap, N_fft, target_F, 'yaxis');
surf(T2, F2, 10*log10(P2), 'edgecolor', 'none');
axis tight;
view(0,90);
colormap(jet);
set(gca,'clim', [-80 -20]);
ylim([2000 4000]);
title('Low High Pass');
xlabel('Time (s)');
ylabel('Frequency (Hz)');

% Spectrogram HighLowpass
subplot(4, 1, 1);
window = hamming(512);
N_overlap = 256;
N_fft = 1024;
[S3, F3, T3, P3] = spectrogram(highlowcleaned, window, N_overlap, N_fft, target_F, 'yaxis');
surf(T3, F3, 10*log10(P3), 'edgecolor', 'none');
axis tight;
view(0,90);
colormap(jet);
set(gca,'clim', [-80 -20]);
ylim([2000 4000]);
title('High High Pass');
xlabel('Time (s)');
ylabel('Frequency (Hz)');

% Spectrogram HighHighpass
subplot(4, 1, 2);
window = hamming(512);
N_overlap = 256;
N_fft = 1024;
[S4, F4, T4, P4] = spectrogram(highhighcleaned, window, N_overlap, N_fft, target_F, 'yaxis');
surf(T4, F4, 10*log10(P4), 'edgecolor', 'none');
axis tight;
view(0,90);
colormap(jet);
set(gca,'clim', [-80 -20]);
ylim([0 2000]);
title('High Low Pass');
xlabel('Time (s)');
ylabel('Frequency (Hz)');

% Save File
filename = 'team[6]-synthesized.wav';
audiowrite(filename,arr1,target_F);
audioinfo(filename);
