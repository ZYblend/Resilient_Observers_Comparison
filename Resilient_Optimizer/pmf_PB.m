function r = pmf_PB(p)
%r = pmf_PB(p) returns the pmf of the sum of mutually independent bernoulli
%              random variables whose inidivual expected values are given
%              in the vector p
%
% Input:
%  - p [n-vector]: non-zero probabilities of success of each of n
%                  individual,independent trials
%
% Output:
%  - r [(n+1)-vector] : vector containing the probablilities of 0
%                       0 successes,1 succes, ... , n successes 
%                       (i.e the entries of the Poisson-Binomial pmf) 

% Olugbenga Moses Anubi 7/22/2020, 
%    Adapted from M. Fernandez, S. Williams, "Closed-Form Expression for 
%                 the Poission-Binomial Probability Density Function", IEEE
%                 Transactions on Aerospace and Electronic Systems, Vol.
%                 46, No. 2, pp 803--817


p(p==0) = [];  % Eliminate any zero elements of vector p

alpha = prod(p);
s = -(1-p)./p;
S = poly(s);     % S = vector with n+1 coefficients of the polynomial whose
                 %     roots are the elements of vector s.
                 
r = flipud(alpha*S(:)); % Reverse the order - since "poly" returns the highest coeefient first
