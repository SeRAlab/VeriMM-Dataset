module top_module (
    input [3:0] i,
    output [3:0] j);

assign j = i >> 1;

endmodule