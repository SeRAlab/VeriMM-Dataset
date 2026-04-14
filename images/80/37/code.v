module top_module(
        input SELECTOR,
        input [63:0] DATA_A,
        input [63:0] DATA_B,
        output [63:0] OUT
    );assign OUT = (SELECTOR == 0) ? DATA_A : DATA_B;
    
endmodule