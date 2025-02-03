function [normaudio,f0,uv,uv_T,reg_ap,bap,sp,spectra] = feature_extraction(filename)

[audio,fs] = audioread(filename);          
normaudio = robustNormalization(audio);   
f0 = Harvest(normaudio,fs);         
%% 非周期性指標推定
ap = D4C(normaudio,fs,f0);      
uv = ap.vuv;
uv_T = uv';                     % 転置した非周期性指標
reg_ap = ap.aperiodicity;
bap = ap.coarse_ap;     % 帯域非周期性指標

%% スペクトル包絡推定
sp = CheapTrick(normaudio,fs,f0);
spectra = sp.spectrogram;

