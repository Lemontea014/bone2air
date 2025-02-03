function [start_Ind,last_Ind] = getindex_(frame_sum,frame_size)

    last_Ind = frame_sum-1;                  %発話の特徴量フレームの最終インデックス
    start_Ind= last_Ind-frame_size+1;

end

