%% This program takes the stress strain data, calculates the slope of each point by fitting a line among the point and next
% three points. This is done for all the data points. Finally the slope at
% each point is plotted with respect to stress
% This script can be modified to change 'k'

clear;
close;

prompt = 'Please enter the stress-strain file name with .txt extension \n';
g_vectorfile = input(prompt);                       
g = fopen(g_vectorfile);                            
testdata = textscan(g, '%f %f');               
l =  length(testdata{1,1}(:));
k=l-4;           % It limits the data to points which have altlest four points beyond it.  


strain = testdata{1,1}(:);  % Strain array is extracted from the input file     
stress = testdata{1,2}(:);  % Stress array is extracted from the input file
fclose(g);

%% Initialization

m=zeros(1,k);
c=zeros(1,k);
Rsq=zeros(1,k);
sigma = zeros(1,k);
epsilon = zeros(1,k);
j=1;

%% 'For' loop for finding out slope at each point
for i=1:1:k
    
    stress1 = [stress(i),stress(i+1),stress(i+2),stress(i+3)]; % Temporary array holds the four points where line is fit
    strain1 = [strain(i),strain(i+1),strain(i+2),strain(i+3)]; % Temporary array holds the four points where line is fit
    
    [xData, yData] = prepareCurveData( strain1, stress1 ); % Input function for fitting program

    %% Polynomial (degree 1) fitting function
    
    ft = fittype( 'poly1' );
    opts = fitoptions( ft );

    opts.Lower = [-Inf -Inf];
    opts.Upper = [Inf Inf];
    
    [f, gof] = fit( xData, yData, ft, opts );
    
%% Assignments of values obtained from the fitting curve

    coeffvals = coeffvalues(f);
    m(j) = coeffvals(1);
    c(j)= coeffvals(2);
    Rsq(j)= gof.rsquare;
    sigma(j)= stress(i);
    epsilon(j)= strain(i);
    j=j+1;
end


figure( 'Name', 'd(sigma)/d(epsilon) vs sigma' );
h = plot( sigma,m );
xlabel( 'Stress' );
ylabel( 'd(sigma)/d(epsilon)' );
grid on
