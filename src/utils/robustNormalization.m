function robust_normalize = robustNormalization(testaudio)

    % ロバスト正規化を行う関数
    % 入力: testaudio - 正規化する信号
    % 出力: robust_normalize - ロバスト正規化された信号

    % 中央値と四分位範囲を計算
    med = median(testaudio);
    iqr_val = iqr(testaudio);

    % 中央値と四分位範囲を使用して正規化
    robust_normalize = (testaudio - med) / iqr_val;
end