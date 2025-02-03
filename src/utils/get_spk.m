function utters = get_spk(wavs)
%GET_UTT この関数の概要をここに記述
%   詳細説明をここに記述
numfiles = length(wavs);
utters = {};
for i = 1:numfiles
    file_name = wavs(i).name;

    % 2回目の "_" の後の部分の最初の1文字を取得
    tokens = regexp(file_name, '^[^_]+_[^_]+_([^\d]+)', 'tokens');
    
    if ~isempty(tokens)
        token = tokens{1}{1}; 
        if ~ismember(token, utters)
            utters{end+1} = token;
        end
    end
end

end

