# knnモデルに基づく音質変換システム
##　推奨環境：
- Windows のみ
- MATLAB 2024a(Signal Processing Tool必須)
##　使用方法：
1. bone2airファイルを、任意のパスに配置
2. bone2air\settings\setting.configを開き、自環境のMATLABパスへ置き換える
```
MATLAB_CMD="put your matlab path"

```
3. run.batファイルを実行
```
cd your_path\bone2air\src\bin\run.bat

```
4. 変換後の音声は、以下のパスに保存されます。
```
your_path\bone2air\data\out_wav

```
## 詳細な使用方法
your_path\bone2air\src\bin\load_dataset.m を開く
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
52行目と62行目のk値を任意の値に変更してください。