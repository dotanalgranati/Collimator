function []=main()
close all
RawData=imread('images\(3680- 20 cm GRID1) -165 normal by GRID profile.tif');
figure(1)
imagesc(RawData); colormap('gray')
[BasicImage]=CropData(RawData);
ElaboratedImage=TestAlgorithm(BasicImage);

function [BasicImage,minX,maxX,minY,maxY]=CropData(RawData)
temp=round(ginput());
minX=min(temp(:,1));
maxX=max(temp(:,1));
minY=min(temp(:,2));
maxY=max(temp(:,2));
xlim([minX maxX]); ylim([minY,maxY])
NonScaledNewImage=RawData(minY:maxY,minX:maxX);
BasicImage=(NonScaledNewImage-min(min(NonScaledNewImage)))/max(max(NonScaledNewImage-min(min(NonScaledNewImage))));
figure
imagesc(BasicImage); colormap('gray')

function ElaboratedImage=TestAlgorithm(BasicImage)

SumofColumns=sum(BasicImage,1)/size(BasicImage,2);
ElaboratedImage=BasicImage./(ones(size(BasicImage,1),1)*SumofColumns); % Equal the sum of all image columns
VerifyFlag=max(abs(sum(ElaboratedImage,1)/(size(BasicImage,2))-1))<1e-3;
if VerifyFlag
    subplot(1,2,1)
    imagesc(BasicImage); colormap('gray')
    title('Basic Image')
    subplot(1,2,2)
    imagesc(ElaboratedImage); colormap('gray')
    title('Proposed Algorithm')
else
    warning('That wasnt the idea')
end

% ProfileAnalysisFlag=0;
% if ProfileAnalysisFlag 
% % Profile Analysis
%     figure(3); temp=round(ginput()); figure(5); 
%     hold all; plot(BasicImage(temp(2),:),'r')
%     figure(3); temp=round(ginput()); figure(5);
%     hold all; plot(BasicImage(temp(2),:),'g'); 
%     figure(3); temp=round(ginput()); figure(5);
%     hold all; plot(BasicImage(temp(2),:),'b');
% end