
bindir=mfilename('fullpath');
parentdir=fileparts(fileparts(fileparts(bindir)));
addpath(genpath(parentdir));
%特定話者のみのデータセットを作成するかどうか
USE_SPECIFIC_SPEAKER =1;
frame_sum=1;
max_frame=500; 
f_bin=513;
default_f0 = 500;
fs=22050;
ncc = 40;
bias=100;
disp("execute load_dataset.m");
datasetdir = fullfile(parentdir, "data", "dataset");


if ~exist(datasetdir, 'dir')
    mkdir(datasetdir);
end

    [result,matfile]=checkmat(datasetdir);
if result
    disp("#############################################");
    disp("#                load matdata               #");
    disp("#############################################");
    load(matfile);
    disp("successs load matdata")
else
    disp("#############################################");
    disp("#          train_feature extraction         #");
    disp("#############################################");
    airdir = fullfile(parentdir, 'data', 'train_wav', 'air_study_22050', '*.wav');
    airwavs = dir(airdir);  
    bonedir = fullfile(parentdir, 'data', 'train_wav', 'bone_study_22050', '*.wav');
    bonewavs = dir(bonedir);
    testdir = fullfile(parentdir, 'data', 'test_wav', 'bone_test', '*.wav');
    testwavs = dir(testdir);
    numfiles = length(airwavs);
    test_num = length(testwavs);
    %テストデータの発話者
    test_spk=get_spk(testwavs);
    if USE_SPECIFIC_SPEAKER == 1
        %configで指定した場合に、特定話者のみのデータセットを構築
        onespk_airwavs =strings(numfiles,1);
        onespk_bonewavs=strings(numfiles,1);
        f_count =1;
        for i = 1:length(airwavs)
        % 現在のファイル名
            air_file_name = airwavs(i).name;
            bone_file_name = bonewavs(i).name;
            % "_" が2回出た後の話者名を取得
            tokens = regexp(air_file_name, '^[^_]+_[^_]+_([^\d]+)', 'tokens');
            
            if ~isempty(tokens)
                train_spk = tokens{1}{1};
                
                % `test_speaker` と一致する場合のみ追加
                if strcmp(train_spk, test_spk)
                    onespk_airwavs(f_count,1) = air_file_name;
                    onespk_bonewavs(f_count,1)= bone_file_name;
                    f_count=f_count+1;
                    %1005
                end
            end
            %行列のresize
            onespk_airwavs=onespk_airwavs(1:f_count-1,:);
            onespk_bonewavs=onespk_bonewavs(1:f_count-1,:);
        end
    end

    if USE_SPECIFIC_SPEAKER == 1
        numfiles = size(onespk_airwavs,1);
    end
    %行列の事前割当て
    airuv_all = zeros(numfiles,max_frame);
    airuv_allT= zeros(numfiles*max_frame,1);
    airrgap_all = zeros(numfiles*max_frame,f_bin);
    airbap_all = zeros(numfiles*max_frame,2);
    airspec_all = zeros(numfiles*max_frame,f_bin);
    bonedata = zeros(numfiles*max_frame,ncc*2);
    deltacep = zeros(numfiles*max_frame,ncc);
    melspecdata = zeros(numfiles*max_frame,ncc);
    frame_size=zeros(1,numfiles);
    Index_info = cell(numfiles, 3);
    for i = 1:numfiles
        Index_info{i, 1} = '';
        Index_info{i, 2} = [];
        Index_info{i, 3} = [];
    end

    for i = 1:numfiles
        if USE_SPECIFIC_SPEAKER == 1
            filename = airwavs(i).folder+"\"+onespk_airwavs(i,:);% import file
        else
            filename = airwavs(i).folder+"\"+airwavs(i).name;% import file
        end
        disp(filename);
        [airaudio,airf0,airuv,airuv_T,airreg_ap,airbap,airsp,airspectra]=feature_extraction(filename);
        
        frame_size(1,i)=size(airuv,2);
        frame_sum=frame_sum +frame_size(1,i);
        [start_Ind,last_Ind] = getindex_(frame_sum,frame_size(1,i));
        Index_info{i, 1} = bonewavs(i).name;
        Index_info{i, 2} = start_Ind;
        Index_info{i, 3} = last_Ind;

        airuv_all(i,1:frame_size(1,i))=airuv;
        airuv_allT(start_Ind:last_Ind,:)= airuv_T;
        airrgap_all(start_Ind:last_Ind,:)=airreg_ap';
        airbap_all(start_Ind:last_Ind,:)=airbap';
        airspec_all(start_Ind:last_Ind,:)=airspectra';

        if USE_SPECIFIC_SPEAKER == 1
            filename = bonewavs(i).folder+"\"+onespk_bonewavs(i,:);% import file
        else
            filename = bonewavs(i).folder+"\"+bonewavs(i).name;
        end
        disp(filename);
        %音響特徴量を抽出
        [boneaudio,bonef0,~,~,~,~,~,bonespectra]=feature_extraction(filename);
        
        f0_sequence = bonef0.f0;
        if isfield(bonef0, 'vuv')
            f0_sequence(bonef0.vuv == 0) = default_f0;
        end

        for j = 1:frame_size(1,i)
            %MFCCとメルスペクトルを抽出
            [coeffs,bone_Melspec] = MFCC(bonespectra,j,fs,ncc);
            current_f0 = f0_sequence(j);
            current_position = bonef0.temporal_positions(j);
            waveform = GetWindowedWaveform(boneaudio, fs, current_f0, current_position);
            power = sum(waveform.^2);
            log_power_db = 10 * log10(power + eps);
            %0次係数を音声の対数パワーへ変更
            coeffs(1) = log_power_db;
            %列方向を平均0、分散1に正規化
            coeffs = normalize(coeffs);

            bonedata(j+frame_sum-1,1:ncc) = coeffs;
            melspecdata(j+frame_sum-1,1:ncc) =bone_Melspec;
        
        end

        % 1次動的特徴量(デルタケプストラム)を計算
        temp = bonedata(start_Ind:last_Ind, 1:ncc);
        delta = calculate_delta(temp,ncc);
        deltacep(start_Ind:last_Ind,:) = delta;
    end
    % 行列のresize
    airuv_allT=airuv_allT(1:last_Ind,:);
    airrgap_all=airrgap_all(1:last_Ind,:);
    airbap_all=airbap_all(1:last_Ind,:);
    airspec_all=airspec_all(1:last_Ind,:);
    bonedata=bonedata(1:last_Ind,:);
    melspecdata=melspecdata(1:last_Ind,:);
    deltacep=deltacep(1:last_Ind,:);

    min_value = min(melspecdata(:)) - bias;
    melspecdata = melspecdata - min_value;
    bonedata(:,ncc+1:end) = deltacep;
    %GVを計算
    std_bonedata = std(bonedata, 1, 1); 
    bonedata_GV = bonedata .* std_bonedata;

    disp("#############################################");
    disp("#                save dataset               #");
    disp("#############################################");

    save(fullfile(datasetdir,'dataset.mat'));
    disp("dataset has saved correctly");
end


