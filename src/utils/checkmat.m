function [result,matfile] = checkmat(directory)
    % 指定したディレクトリ内の .mat ファイルを検索
    files = dir(fullfile(directory, '*.mat'));
    
    % .mat ファイルが1つ以上あれば true, なければ false
    result = ~isempty(files);

    if result ==1
        matfile = fullfile(directory, files(1).name);
    else
        matfile =[];
    end
    
end

