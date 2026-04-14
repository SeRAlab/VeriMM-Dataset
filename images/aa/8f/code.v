module top_module(X, Y, SUM, C_out);input X;
input Y;
output SUM;
output C_out;
assign SUM = X ^ Y ;
assign C_out = X & Y ;endmodule