classdef knn_model < handle
    % このクラスの概要をここに記述
    %   詳細説明をここに記述
    
    properties
        knn
        bone_air_specall
        bone_air_airrgapall
        bone_air_airbapall
    end
    
    methods
        function obj = knn_model(struct)
            % このクラスのインスタンスを作成
            %   詳細説明をここに記述
            obj.knn = struct;
            obj.bone_air_specall=zeros(size(obj.knn.testdata,1),size(obj.knn.airspec_all,2));
            obj.bone_air_airrgapall=zeros(size(obj.knn.testdata,1),size(obj.knn.airrgap_all,2));
            obj.bone_air_airbapall=zeros(size(obj.knn.testdata,1),size(obj.knn.airbap_all,2));
        end

        %knnによるパラメータ推定アルゴリズム
        function result = output(obj)

            for i = 1:size(obj.knn.testdata,1)
                %テストデータと、データセットのユークリッド距離を測定
                dist = obj.calcdist(i);
                %Indexを昇順ソート
                [long,Index] = sort(dist);
                % %フレーム方向に整列&先頭5つのインデックスを取得
                [klong,kInd] = obj.uv_flag(long,Index,i);
                k_chosenspec = obj.knn.airspec_all(kInd(:,1),:);
                k_chosenrgap = obj.knn.airrgap_all(kInd(:,1),:);
                k_chosenbap = obj.knn.airbap_all(kInd(:,1),:);

                bone_air_spec = mean(k_chosenspec);
                bone_air_airrgap=mean(k_chosenrgap);
                bone_air_airbap=mean(k_chosenbap);

                obj.bone_air_specall(i,:)=bone_air_spec;
                obj.bone_air_airrgapall(i,:)=bone_air_airrgap;
                obj.bone_air_airbapall(i,:)=bone_air_airbap;
            end 
            result = struct(...
                            'bone_air_spec', obj.bone_air_specall', ...
                            'bone_air_airrgap', obj.bone_air_airrgapall', ...
                            'bone_air_airbap', obj.bone_air_airbapall' ...
                            );

        end
    end

    methods (Access = protected)
        function dist = calcdist(obj, i)

            specdif = obj.knn.bonedata - obj.knn.testdata(i,:);
            dist = sum(((specdif).^2), 2);

        end

        function [klong, kInd] = uv_flag(obj,long,Index,i)
            count = 1;
            kInd=zeros(5, 1);
            klong=zeros(5, 1);
            for j = 1:size(Index,1)
                if obj.knn.testuv(1,i) == obj.knn.airuvT(Index(j,1),1)
                    kInd(count, 1) = Index(j);
                    klong(count,1) = long(j);
                    count = count + 1;
                    %先頭から5つ選択するまでループ
                    if count > obj.knn.k
                        break;
                    end
                end
            end
        end
    end
end

