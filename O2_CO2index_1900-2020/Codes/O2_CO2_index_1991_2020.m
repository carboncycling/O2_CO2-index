function O2_OCI()

Step = 'Reading the data...'

T=xlsread('Month_Stations_O2_CO2.xlsx','A1:L3500');

AGE=T(:,1);
OCI=T(:,2);

Element=T(:,2);
sampleN=length(AGE);

OutlierH=quantile(Element,0.99);
OutlierL=quantile(Element,0.01);

for i = 1:1: sampleN;   % remove the outliers
    if Element(i)>OutlierH | Element(i)<OutlierL
        Element(i)=nan;
    end
end

X1= 2021;
X2 = 2022;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

AA=Element;

low = X1;
high = X2;

nA=[];

for j = 1:1:31
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

csvwrite('O2_CO2index1991_2020.csv',result);