
%メルフィルタバンクの設計
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [FilterBank, fcenters] = melFilterBank(fs, N, numChannels)
%%メルフィルタバンクを作成%%
    fmax = fs / 2;
    % ナイキスト周波数（mel）
    melmax = hz2mel(fmax);
    % 周波数インデックスの最大数
    nmax = fix(N/2) + 1;
    % 周波数解像度（周波数インデックス1あたりのHz幅）
    df = fs / N;
    % メル尺度における各フィルタの中心周波数を求める
    dmel = melmax / (numChannels + 1);
    mel_arange = 1:numChannels;
    melcenters =  mel_arange * dmel;

    % 各フィルタの中心周波数をHzに変換
    fcenters = mel2hz(melcenters);
    % 各フィルタの中心周波数を周波数インデックスに変換
    indexcenter = round(fcenters / df);
    % 各フィルタの開始位置のインデックス
    indexstart = [0, indexcenter(1:numChannels - 1)];
    % 各フィルタの終了位置のインデックス
    indexstop = [indexcenter(2:numChannels), nmax];

    filterbank = zeros(numChannels, nmax);

    for c = 1:numChannels
        % 三角フィルタの左の直線の傾きから点を求める
        increment = 1.0 / (indexcenter(c) - indexstart(c));
        for i = indexstart(c):(indexcenter(c))

            if indexstart(c) > 0 && i > 0  % インデックスが0より大きいか確認
            filterbank(c, i) = (i - indexstart(c)) * increment;
            end
        end
        % 三角フィルタの右の直線の傾きから点を求める

        decrement = 1.0 / (indexstop(c) - indexcenter(c));
        for i = indexcenter(c):(indexstop(c))

            if indexstart(c) > 0 && i > 0
            filterbank(c, i) = 1.0 - ((i - indexcenter(c)) * decrement);
            end

        end

    end

    FilterBank = filterbank ;
  

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function hz_to_mel = hz2mel(f)
    %Hzをmelに変換%
    hz_to_mel = 2595 * log(f / 700.0 + 1.0);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function mel_to_hz = mel2hz(m)
    %melをhzに変換%
    mel_to_hz = 700 * (exp(m / 2595) - 1.0);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

