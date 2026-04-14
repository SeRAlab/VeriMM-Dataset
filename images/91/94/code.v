module top_module( Q,J,K,clk,R);output Q; 
input J, K, clk, R ; 
wire a,b,q1,q2; 
wire Qbar;


nand #2 N1 (a, clk, J, q2); 
nand #2 N2 (b, clk, K, q1);
nand #2 N3 (q1, a, q2);
nand #2 N4 (q2, b, q1, ~R); 
assign Q=q1; 
assign Qbar=q2;
assign Q=~Qbar; 				
endmodule