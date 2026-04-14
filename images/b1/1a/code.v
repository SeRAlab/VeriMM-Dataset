module top_module(T1,T0,out);input T1;
input T0;
output [3:0] out;

assign out = {1'b0,1'b0, T1, T0};

endmodule