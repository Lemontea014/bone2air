%% Reference
% WORLD法で推定したスペクトル包絡に適用可能なMFCC計算機です。
%
%関数MFCC(spectrogram,frame_number, fs)
% には、スペクトル包絡,時間フレーム数,サンプリング周波数を渡してください。
%


function [MFCC,MelSpectrum_2]  = MFCC(spectrogram,frame_number, fs,ncc)

%% デフォルトは22050Hz
if nargin < 3
fs = 22050;
end

%% WORLD法に基づいたFFT長の計算
f0_low_limit = 71;
N = 2 ^ ceil(log2(3 * fs / f0_low_limit + 1));

%% 列長を周波数軸成分に変換
f = (0:(N/2)) * (fs / N); 

%% メルフィルタバンクの設計
Filter_2 = melfilter(ncc,f);

%% メルフィルタバンクとスペクトル包絡の内積を取る。
amplitudeSpectrum = abs(spectrogram);
MelSpectrum_2 = Filter_2 * amplitudeSpectrum(:,frame_number);

MelSpectrum_2 = 20 * log10( MelSpectrum_2 + eps); %メルスペクトル包絡を、対数パワーに変換。

%% 取得したメルスペクトルを、離散コサイン変換を行う。
MFCC = dct(MelSpectrum_2);

MFCC = MFCC';                                     %MFCCを転置
MelSpectrum_2 = MelSpectrum_2';                   %メルスペクトルを転置

%% 重み値は可変
%MFCC(1) = MFCC(1) * 0.1;
MFCC(2) = MFCC(2) * 0.3; 

end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [Filter,MelFrequencyVector] = melfilter(N,FrequencyVector,hWindow)

%% フィルタバンクの行列設計　
if nargin<3 || isempty(hWindow), hWindow = @triang; end %第三引数のデフォは三角窓

%%　
MelFrequencyVector = 2595*log10(1+FrequencyVector/700);   % メルスケール変換
MaxF = max(MelFrequencyVector);                 % 
MinF = min(MelFrequencyVector);                 %
MelBinWidth = (MaxF-MinF)/(N+1);                % 植木算なのでN+1等分する。
Filter = zeros([N numel(MelFrequencyVector)]);  % N行MelFrequencyVector列の空行列作成

%% N次元フィルタバンクの構築
for i = 1:N
    iFilter = find(MelFrequencyVector>=((i-1)*MelBinWidth+MinF) & ...
                    MelFrequencyVector<=((i+1)*MelBinWidth+MinF));
    Filter(i,iFilter) = hWindow(numel(iFilter)); % 有効値を三角窓に適用
end

Filter = full(Filter);    % 行列に変更

end