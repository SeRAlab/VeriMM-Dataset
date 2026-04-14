module top_module(a0,a1,a2,a3,s0,s1,op);input a0,a1,a2,a3;
input s0,s1;
output op;

assign op = s1?(s0?a3:a2):(s0?a1:a0);endmodule