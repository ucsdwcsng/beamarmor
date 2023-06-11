clear;
syms a b c d x real;
P(x) = exp(2*pi*1i*x)*(c^2+d^2)+exp(pi*1i*x)*(4*a*b*c*d)+a^2+b^2;
assume(x>0 & x<2*pi);
eqn = diff(P,x) == 0;
solve(eqn,x,'ReturnConditions',true)