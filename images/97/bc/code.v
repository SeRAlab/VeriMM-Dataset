module top_module(input [31:0] nor_a, nor_b,
            output [31:0] result_nor);assign result_nor = ~(nor_a|nor_b);endmodule