function CH4_region()

Step = 'Reading the data...'

T=xlsread('methane_content_stations.csv','A1:O2174');

AGE=T(:,4);
CH4_region=T(:,3);

Element=T(:,3);
sampleN=length(AGE);

OutlierH=quantile(Element,0.95);
OutlierL=quantile(Element,0.05);

for i = 1:1: sampleN;   % remove the outliers
    if Element(i)>OutlierH | Element(i)<OutlierL
        Element(i)=nan;
    end
end

X1= 2019;
X2 = 2020;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

AA=Element;

low = X1;
high = X2;

nA=[];

for j = 1:1:35
    Step = j ;
    dataAA=[];
    BinAA=[];
    BSmean_AA=[];
    
    for i = 1:1:sampleN   %constrain value in specific range.
        
        if AGE(i) >= low & AGE(i) <= high
            BinAA(i)=AA(i);
        else
            BinAA(i)=nan;
        end
    end
    
    dataAA=BinAA(~isnan(BinAA));
    nA(j)=length(dataAA);
    
    % Bootstrap estimation for mean and standard error
    
    BSmean_AA = bootstrp(10000, @mean, dataAA);
    
    result1(j,1)=(low+high)/2;    %age
    result1(j,2)=mean(BSmean_AA);       %mean
    result1(j,3)=2*std(BSmean_AA);      %standard error
    result1(j,4)=nA(j);
    
    
    low = low-1;      %define the bin size (step width)
    high = high-1;    %define the bin size (step width)
    
end

figure(1)
hold on
eb1=errorbar(result1(:,1),result1(:,2),result1(:,3));  
result=[result1(:,1),result1(:,2),result1(:,3)];

csvwrite('CH4_permafrost regions.csv',result);