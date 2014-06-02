function [BasicImageStatistics,ElaboratedImageStatistics]=main()
close all
RawData=imread('images\(3680- 20 cm GRID1) -165 normal by GRID profile.tif');
figure(1)
imagesc(RawData); colormap('gray')
[BasicImage,BasicImageStatistics]=CropData(RawData);
[ElaboratedImage,ElaboratedImageStatistics]=TestAlgorithm(BasicImage);
g=3;

function [BasicImage,statistics]=CropData(RawData)
temp=round(ginput());
minX=min(temp(:,1));
maxX=max(temp(:,1));
minY=min(temp(:,2));
maxY=max(temp(:,2));
xlim([minX maxX]); ylim([minY,maxY])
NonScaledNewImage=RawData(minY:maxY,minX:maxX);
BasicImage=(NonScaledNewImage-min(min(NonScaledNewImage)))/max(max(NonScaledNewImage-min(min(NonScaledNewImage))));
statistics=FindStatistics(BasicImage);
figure
imagesc(BasicImage); colormap('gray')

function [ElaboratedImage1,statistics]=TestAlgorithm(BasicImage)

SumofColumns=sum(BasicImage,1)/size(BasicImage,2);
ElaboratedImage1=BasicImage./(ones(size(BasicImage,1),1)*SumofColumns); % Equal the sum of all image columns
SumofRows=sum(ElaboratedImage1,2)/size(ElaboratedImage1,1);
ElaboratedImage2=ElaboratedImage1./(SumofRows*ones(1,size(ElaboratedImage1,2))); % Equal the sum of all image columns

VerifyFlag=max(abs(sum(ElaboratedImage1,1)/(size(BasicImage,2))-1))<1e-3;
if VerifyFlag
    subplot(1,3,1)
    imagesc(BasicImage); colormap('gray')
    title('Basic Image')
    subplot(1,3,2)
    imagesc(ElaboratedImage1); colormap('gray')
    title('Proposed Algorithm on Columns')
    subplot(1,3,3)
    imagesc(ElaboratedImage2); colormap('gray')
    title('Proposed Algorithm on Columns and Rows')
else
    warning('That wasnt the idea')
end
statistics=FindStatistics(ElaboratedImage1);

function statistics=FindStatistics(Image)
if isempty(Image)
    statistics=[];
    return
end
statistics(1)=mean(Image(:));
statistics(2)=std(Image(:));
statistics(3)=statistics(2)/statistics(1);

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