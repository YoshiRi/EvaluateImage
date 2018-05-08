%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 2018 4/18  Yoshi R @ Univ. Tokyo
% Free LICENSE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

classdef evaluate_image
    % Functions to evaluate images
    %   SSD: Sum of Squared Difference
    %   SAD: Sum of Absolute Difference
    %   NCC: Normalized Cross Correlation
    %   ZNCC: Zero-meand Normalized Cross Correlation
    %   MI: Mutual Information
    
    properties
        % Curretly None
    end
    
    methods
        function obj = evaluate_image()
            %Make class instance
            %   No description. Just use these function.
        end
        
        %% SSD %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function e = SSD(img1,img2)
            % Input: image1,image2            
            if(~(size(img1)==size(img2)))
                error('Image size should be the same!');
            end
            
            [height,width] = size(img1);
            Total = height * width;
                        
            % Substractg image one by one
            MX = double(img1) - double(img2);
            % Adding up squared errors with matrix form
            VX = reshape(MX,[1 numberofelements(MX)]);
            VY = VX.';
            
            e = VX * VY ;
        end
        
        
        %% SAD %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function e = SAD(img1,img2)
            % Input: image1,image2
            if(~(size(img1)==size(img2)))
                error('Image size should be the same!');
            end
            
            [height,width] = size(img1);
            Total = height * width;
                        
            % Substractg image one by one
            MX = abs( double(img1) - double(img2));
            % Adding up squared errors with matrix form
            e = sum(sum(MX));
        end
        
        % Normalized correlation
        %% NCC %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function e = NCC(img1,img2)
            % Input: image1,image2
            img1 = double(img1);
            img2 = double(img2);
            
            if(~(size(img1)==size(img2)))
                error('Image size should be the same!');
            end
            
            % Take correlation
            V1 = reshape(img1,[1 numel(img1)])  ;
            V2 = reshape(img2,[1 numel(img2)])  ;
            
            % Normalization
            Nolm =sqrt(  V1* V1.' * V2 * V2.' );
            e = (V1 * V2.') / Nolm;
        end
        
        
        %% ZNCC %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function e = ZNCC(img1,img2)
            % Input: image1,image2
            img1 = double(img1);
            img2 = double(img2);
            
            if(~(size(img1)==size(img2)))
                error('Image size should be the same!');
            end
            % Get Correlation
            % Get mean intensity
            avg1 = mean2(img1);
            avg2 = mean2(img2);
            
            % Calculate correlation
            V1 = reshape(img1,[1 numel(img1)])  - avg1;
            V2 = reshape(img2,[1 numel(img2)])  - avg2;
            
            Nolm =sqrt(  V1* V1.' * V2 * V2.' );
            e = (V1 * V2.') / Nolm;
        end
        
        %% MI %%%%%%%%%%%%%%%%%%%%%%%
        function mu = MI(img1,img2, grad)
            % Mutual Information estimation
            % Input : two image and gradation(additional)
            %       : default gradation is set to 64
            if(~(size(img1)==size(img2)))
                error('Image size should be the same!');
            end
            % Default gradation
            if nargin==2
                grad = 64;
                print('Set defalt gradation as 64.')
            end
            
            [height,width] = size(img1);
            Total = height * width;
            
            % matrix for histogram
            hist1= zeros(grad,1);
            hist2= zeros(grad,1);
            hist12= zeros(grad);
            
            % histogram
            Igrad = 256/grad;
            for i = 1:height
                for j = 1:width
                    a = floor(double(img1(i,j))/Igrad);
                    b = floor(double(img2(i,j))/Igrad);
                    hist1(a+1)=hist1(a+1)+1;
                    hist2(b+1)=hist2(b+1)+1;
                    hist12(a+1,b+1)=hist12(a+1,b+1)+1;
                end
            end
            
            % Convert to probability
            hist1=hist1/Total;
            hist2=hist2/Total;
            hist12=hist12/Total;
            
            % Calculations of MI
            % need to abvoid log0
            H1 = 0;
            H2 = 0;
            H12 = 0;
            for i=1:grad
                for j =1:grad
                    if(not(hist12(i,j)==0))
                        H12 = H12 - hist12(i,j)*log2(hist12(i,j));
                    end
                end
                if(not(hist1(i)==0))
                    H1 = H1 - hist1(i)*log2(hist1(i));
                end
                if(not(hist2(i)==0))
                    H2 = H2 - hist2(i)*log2(hist2(i));
                end
            end
            mu = H1+H2-H12;
        end
        
    end
end

