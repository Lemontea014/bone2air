
 % MFCCdata = csvread('mfcc10.csv');
 % delta = calculate_delta(MFCCdata, 10);

function delta = calculate_delta(MFCCdata, coeficientNumber)
% 始端終端に2フレーム追加
newdata = [ MFCCdata(1,:) ; 
            MFCCdata(1,:) ; 
            MFCCdata(:,:) ; 
            MFCCdata(end,:) ; 
            MFCCdata(end, :) ];

delta = zeros(size(MFCCdata));
onecoeficient_delta = zeros(size(MFCCdata,1),1);

for iter = 1:coeficientNumber
for count = 3 : 1 : (length(newdata) - 2)
    %disp( newdata(count-2:count+2, 1) );
    %周囲 5 フレームの回帰係数を求める
    y = newdata(count-2:count+2, iter);
    x = [1 1 ;1 2 ;1 3 ;1 4 ;1 5];
    coefficient = polyfit(x(:,2), y, 1);  % 線形回帰
    onecoeficient_delta(count-2) = coefficient(1) ; %polyfitの1次は傾きを返す。
end
    delta(:,iter) = onecoeficient_delta;
end
end