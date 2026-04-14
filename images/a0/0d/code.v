module top_module(
    input [3:0] a,
    output [3:0] result);

assign result = a >> 1;

endmodule