module top_module(a,b,c_in,s,c_out);input a;
input b;
input c_in;
output s;
output c_out;

assign s = a ^ b ^ c_in;
assign c_out = (a & b) | ( (a ^ b) & c_in );endmodule