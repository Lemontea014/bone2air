%%  Test script for WORLD analysis/synthesis with new waveform generator
% 2018/04/04: First version

[x, fs] = audioread('ohayougozaimasu_04.wav');

f0_parameter = Harvest(x, fs);%Harvestで基本周波数を抽出
f0_parameter.f0 = f0_parameter.f0 * 0.7;
spectrum_parameter = CheapTrick(x, fs, f0_parameter);%スペクトル包絡を抽出
source_parameter = D4CRequiem(x, fs, f0_parameter);%帯域非周期性の抽出


seeds_signals = GetSeedsSignals(fs);
y = SynthesisRequiem(source_parameter, spectrum_parameter, seeds_signals);

sound(y, fs);

% または、音声をファイルに保存して後で再生することもできます
audiowrite('synthesized_audio.wav', y, fs);