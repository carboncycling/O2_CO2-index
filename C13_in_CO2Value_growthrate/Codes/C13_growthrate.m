function C13_growthrate()

Step = 'Reading the data...'

T=xlsread('C13_CO2growth rate.xlsx','A1:C400');

AGE=T(:,1);
slope=T(:,2);

Element=T(:,2);
sampleN=length(AGE);

X1= 2014;
X2 = 2024;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

AA=Element;

low = X1;
high = X2;

nA=[];

for j = 1:1:120
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

csvwrite('C13_in_CO2 growthrate.csv',result);