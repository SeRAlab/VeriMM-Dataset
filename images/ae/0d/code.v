module top_module(
    input [31:0]RData2,
    input [31:0]Extended,
    input ALUSrc,
    output [31:0]ALUB
    );assign ALUB = (ALUSrc == 1) ? Extended : RData2;

endmodule