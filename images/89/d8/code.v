module top_module(y,a,b,c,d,s1,s0);output y;
input a,b,c,d,s1,s0;
assign y = ((a & ~s1 & ~s0) | (b & ~s1 & s0) | (c & s1 & ~s0) | (d & s1 & s0));endmodule