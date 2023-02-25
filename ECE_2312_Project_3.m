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

recorder = audiorecorder(Fs, nBits, nChannels, 1);

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

F = [0 passband_end stopband_st 1];
A = [1 1 0 0];
lpf = firls(255, F, A);
filtered = filter(lpf, A, arr);
cleaned = downsample(filtered, 5);

sound(cleaned, Fs)
clf
% Time Plot
% % t = [0: length(y)-1]/ Fs;
% % plot(t, y)
% % title("Audio")
% % xlabel("Time (sec)")
% % ylabel("Magnitude")

% Spectrogram
window = hamming(512);
N_overlap = 256;
N_fft = 1024;
[S, F, T, P] = spectrogram(cleaned, window, N_overlap, N_fft, target_F, 'yaxis');
figure;
surf(T, F, 10*log10(P), 'edgecolor', 'none');
axis tight;
view(0,90);
colormap(jet);
set(gca,'clim', [-80 -20]);
ylim([0 8000]);
xlabel('Time (s)');
ylabel('Frequency (Hz)');

% Save File
% filename = 'team[6]-stereosoundfile.wav';
% audiowrite(filename,arr1,Fs);
% audioinfo(filename);
