# knnモデルに基づく音質変換システム
## 推奨環境：
- Windows 10以上推奨
- MATLAB 2024a以上推奨(**Signal Processing Toolbox必須**)
## 使用方法：
1. bone2airフォルダを、任意のパスに配置する。
2. `bone2air\settings` 直下にある `setting.config` を開き、自環境のmatlab.exeが存在するパスへ置き換える
```
MATLAB_CMD="put your matlab path"
```
3. `run.bat`を実行
```
cd your_path\bone2air\src\bin
```
```
run.bat
```
4. 変換後の音声は、以下のパスに保存されます。
```
your_path\bone2air\data\out_wav
```
## 詳細な使用方法
`your_path\bone2air\src\bin` 直下にある `load_dataset.m` を開く
### 変換元の音声の話者と、データセットの話者を統一させる場合
```
#特定話者のデータのみ利用
USE_SPECIFIC_SPEAKER =1;
```
### 話者性にかかわらず、データセットを利用する場合
```
#すべてのデータを利用
USE_SPECIFIC_SPEAKER =0;
```
### kの値を変える
1. `your_path\bone2air\src\bin` 直下にある `synthesis_knn.m` を開く。
2. `synthesis_knn.m` 52行目と62行目の`k`を任意の値に変更してください。

## reference
[WORLD](https://github.com/mmorise/World)
