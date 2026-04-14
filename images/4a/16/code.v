module top_module(y,s0,s1,in);output y;
input s0,s1;
input  [3:0] in;
assign y=((~s0)&(~s1)&in[0])|((~s0)&s1&in[1])|(s0&(~s1)&in[2])|(s0&s1&in[0]);endmodule