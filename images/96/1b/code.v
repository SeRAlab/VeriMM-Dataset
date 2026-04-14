module top_module(I, O);input  [4:0] I;
output [2:0] O;

assign O = I[4] + I[3] + I[2] + I[1] + I[0];

endmodule