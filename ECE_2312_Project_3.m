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

nBits = 8;
nChannels = 1;

%recorder = audiorecorder(Fs, nBits, nChannels, 1);

pause(1);
disp("Get Ready")
pause(1);
% 
% disp("3")
% pause(1);
% 
% disp("2")
% pause(1);
% 
% disp("1")
% pause(1);
% 
disp("Sound")

%record(recorder, duration);
%sound(arr, Fs)

% Wait 5 seconds
% pause(duration);
% disp("Recording over")

%arr1 = getaudiodata(recorder, "double");

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

lowfiltered = filter(lpf, A, arr);
highfiltered = highpass(arr, highpassband, target_F);

lowcleaned = downsample(lowfiltered, factor);
highcleaned = downsample(highfiltered, factor);

%sound(lowcleaned, target_F)

clf
% Time Plot
% % t = [0: length(y)-1]/ Fs;
% % plot(t, y)
% % title("Audio")
% % xlabel("Time (sec)")
% % ylabel("Magnitude")

% Spectrogram Lowpass
figure;
window = hamming(512);
N_overlap = 256;
N_fft = 1024;
[S1, F1, T1, P1] = spectrogram(highcleaned, window, N_overlap, N_fft, target_F, 'yaxis');
surf(T1, F1, 10*log10(P1), 'edgecolor', 'none');
axis tight;
view(0,90);
colormap(jet);
set(gca,'clim', [-80 -20]);
ylim([0 4000]);
title('High Pass');
xlabel('Time (s)');
ylabel('Frequency (Hz)');

% Spectrogram Highpass
figure;
window = hamming(512);
N_overlap = 256;
N_fft = 1024;
[S, F, T, P] = spectrogram(lowcleaned, window, N_overlap, N_fft, target_F, 'yaxis');
surf(T, F, 10*log10(P), 'edgecolor', 'none');
axis tight;
view(0,90);
colormap(jet);
set(gca,'clim', [-80 -20]);
ylim([0 4000]);
title('Low Pass');
xlabel('Time (s)');
ylabel('Frequency (Hz)');

% Save File
% filename = 'team[6]-stereosoundfile.wav';
% audiowrite(filename,arr1,Fs);
% audioinfo(filename);
