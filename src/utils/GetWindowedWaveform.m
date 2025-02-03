function waveform = GetWindowedWaveform(x, fs, current_f0, current_position)
%  prepare internal variables
half_window_length = round(1.5 * fs / current_f0);
base_index = (-half_window_length : half_window_length)';
index = round(current_position * fs + 0.001) + 1 + base_index;
safe_index = min(length(x), max(1, round(index)));

%  wave segments and set of windows preparation
segment = x(safe_index);
time_axis = base_index / fs / 1.5;
window = 0.5 * cos(pi * time_axis * current_f0) + 0.5;
window = window / sqrt(sum(window .^ 2));
waveform = segment .* window - window * mean(segment .* window) / mean(window);
end