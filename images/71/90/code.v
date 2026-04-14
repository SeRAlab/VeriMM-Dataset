module top_module(input [15:0] immediate,input ExtSel,output [31:0] result);assign result[15:0] = immediate;
    assign result[31:16] = ExtSel ? (immediate[15]==1 ? 16'b1111111111111111: 16'b0000000000000000) : 16'b0000000000000000;
endmodule