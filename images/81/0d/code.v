module top_module(
        input SELECTOR,
        input [4:0]DATA_A,
        input [4:0]DATA_B,
        output [4:0] OUTPUT
    );assign OUTPUT = (SELECTOR == 0) ? DATA_A : DATA_B;
endmodule