module top_module(input [31:0] a, output [31:0] y);assign y = {a[25:0], 2'b00};
endmodule