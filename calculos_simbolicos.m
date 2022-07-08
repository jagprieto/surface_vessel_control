clc;
clear("all");

syms x y yaw u v r du dv dr tu tr m11 m22 m23 m32 m33 c13 c23 d11 d22 d23 d32 d33;

velocity = [u; v; r];
disturbance = [du; dv; dr];
control = [tu; 0 ; tr];

M = simplify([m11 0 0; 0 m22 m23; 0 m32 m33])
C = simplify([0 0 c13; 0 0 c23; -c13 -c23 0]);
D = simplify([d11 0 0; 0 d22 d23; 0 d32 d33]);
R = [cos(yaw) -sin(yaw) 0 ; sin(yaw) cos(yaw) 0; 0 0 1];
INV_M = simplify(inv(M))

S = simplify([0 -r 0;r 0 0; 0 0 0]);
PI = simplify(R*INV_M);
SIGMA = simplify(- C*velocity - D*velocity);
GAMMA = simplify(R*S*velocity -PI*SIGMA);
THETA = simplify(-PI*disturbance);

% pi_tau = simplify(PI*control)
% GAMMA
% THETA




% syms omega yaw u v r xg m m11 m22 m23 m32 m33 c13 c23 d11 d22 d23 d32 d33 Xdu Ydv Ydr Ndv Ndr Xu Xuu Xuuu Yv Yvv Yr Yvr Yrr Nv Nvv Nrv Nvr Nr Nrr Iz;
% 
% % yaw = 0;
% 
% 
% m11 = m - Xdu;
% m22 = m - Ydv;
% m23 = m*xg - Ydr;
% m32 = m*xg - Ndv;
% m33 = Iz - Ndr;
% c13 = -m11*v -m23*r;
% c23 = m11*u;
% d11 = -Xu - Xuu*abs(u) - Xuuu*u*u;
% d22 = -Yv - Yvv*abs(v);
% d23 = -Yr - Yvr*abs(v) - Yrr*abs(r);
% d32 = -Nv - Nvv*abs(v) - Nrv*abs(r);
% d33 = -Nr - Nvr*abs(v) - Nrr*abs(r);
% 
% 
% M = simplify([m11 0 0; 0 m22 m23; 0 m32 m33]);
% C = simplify([0 0 c13; 0 0 c23; -c13 -c23 0]);
% D = simplify([d11 0 0; 0 d22 d23; 0 d32 d33]);
% N = - C*V - D*V;
% R = [cos(yaw) -sin(yaw) 0 ; sin(yaw) cos(yaw) 0; 0 0 1];
% INV_M = simplify(inv(M));
% B = simplify(R*INV_M);
% INV_B = simplify(inv(B))
% 
% 
% omega = R*V
% S_OMEGA_3 = [0 -r 0;r 0 0; 0 0 0];
% H = simplify(S_OMEGA_3*omega + B*N) 

% 
% A = [-L1  1 0;-L2 0 1;-L3 0 0 ]
% % eigA = simplify(eig(A))
% % p1 = (L2+1)/(2*L1);
% % p2 = (((L1+L3)/2) + p1)/L2;
% % p3 = ((L2/2)-0.5)/L3;
% % P = [p1 -0.5 0;-0.5 p2 -0.5; 0 -0.5 p3]
%  P = [p1 -0.5;-0.5 p2]
% eigP = simplify(eig(P))
% 
% % Q = -simplify(P*A + transpose(A)*P)
% % eigQ = simplify(eig(Q))
% 
% % syms k1 k2;
% % A = [-k1  1;-k2 0]
% % eigA = simplify(eig(A))
% 
% % 
% % syms k1 k2 delta p1 p2 p3 F1 F2 beta kppa;
% % 
% % 
% % P = [p1 -0.5;-0.5 p2]
% % detP = simplify(det(P))
% % eigP = simplify(eig(P))
% % 
% % % disp('----------------------------S1---------------------')
% % % alfa = lambda*lambda / 4;
% % % delta = 1/lambda;
% % % A = [-lambda  1;-alfa 0]
% % % P = [1 -delta;-delta 1/alfa]
% % % detP = simplify(det(P))
% % % Q = simplify(P*A + transpose(A)*P)
% % % detQ = simplify(det(Q))
% % 
% % % disp('----------------------------S2---------------------')
% % % 
% % % A = [-k1*delta  1;-k2*delta 0]
% % % 
% % % p1 =  simplify( (1+(lambda^2/4)) / (2*lambda))
% % % p2 = simplify( 4*(p1+0.5*lambda) / (lambda^2))
% % % p3 = simplify((4*p2*p1 - 1)/(4*p2))
% % % 
% % % % p123 = simplify(p1-(p2^2/p3))
% % % % p23 = simplify(-p2/p3)
% % % % p1p3 = simplify((4*p1*p3 - 1)/(4*p3))
% % % % 
% % % P = [p1 -0.5;-0.5 p2]
% % % detP = simplify(det(P))
% % % % eigP = simplify(eig(P))
% % % Q = simplify(P*A + transpose(A)*P)
% % 
% % 
% % 
% % 
% % 
% % % 
% % % F2 = simplify((-p2/p3)*F1)
% % % exp2 = simplify(p2*F1 + p3*F2)
% % % exp1 = simplify(p1*F1 + p2*F2)
% % % kappa = simplify(2*(p1+lambda/2)/(lambda^2)*beta)
% % % 
% % % eigP = simplify(eig(P))
% % 
% % % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% % % disp('********************* CASO 2 **********************')
% % % syms lambda alfa p1 p3;
% % % alfa = lambda^2 / 4;
% % % p2 = 0.5/lambda
% % % p3 = simplify((lambda +1)/(2*lambda*alfa))
% % % p1 =  simplify(alfa/(2*lambda) + (lambda + 1)/(2*alfa))
% % % A = [0 1;-lambda -alfa]
% % % % P = simplify([p1 0.5/lambda;0.5/lambda p3])
% % % P = simplify([p1 p2;p2 p3])
% % % detP = simplify(det(P))
% % % Q = simplify(P*A + transpose(A)*P)
% % % detQ = simplify(det(Q))
% % %  
% % % eigP = simplify(eig(P))
% % 
% % %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%5
% % 
% % % disp('*******************************************')
% % % % lambda = 5
% % % % alfa = lambda*lambda/45
% % % lambda = 1
% % % alfa = lambda*lambda/4
% % % A = [0 1;-lambda -alfa]
% % % Q = [1 0;0 1]
% % % P = lyap(A', Q)
% % % detP = (det(P))
% % % QP1 = A*P + P*transpose(A)
% % % QP2 = P*A + transpose(A)*P
% % % 






% 
% disp('*******************************************')
% % lambda = 5
% % alfa = 1
% % Q = [1 0;0 1]
% % P = lyap(A, Q)
% 
% 
% 

% % eigA = eig(A)
% % P = [1 0.5;0.5 delta]
% P = [1 delta;delta 1/alfa]
% detP = simplify(det(P))
% Q = simplify(P*A + transpose(A)*P)
% detQ = simplify(det(Q))
% 
% % P = [mu delta;delta 1/alfa]
% % % P = [1/alfa -delta;-delta 1]
% % % P = [delta 1;1/alfa delta]
% % 
% % detP = simplify(det(P))
% % Q = simplify(P*A + transpose(A)*P)
% % 
