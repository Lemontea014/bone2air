classdef isdknn_model < knn_model
    methods(Access = protected)
        %override
        function dist = calcdist(obj, i)
            ratio = obj.knn.bonedata ./ obj.knn.testdata(i,:);
            dist = sum((ratio - log(ratio) - 1),2);
        end
    end
end

