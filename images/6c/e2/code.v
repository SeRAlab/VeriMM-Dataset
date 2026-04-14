module top_module(a, b, p);input signed [20 - 1 : 0] a;
input [8 - 1 : 0] b;
output signed [28 - 1 : 0] p;

assign p = $signed (a) * $signed ({1'b0, b});

endmodule