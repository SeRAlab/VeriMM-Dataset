module top_module(output wire [15:0] out, input wire [3:0] A);assign out = 1 << A;

endmodule