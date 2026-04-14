module top_module(
    input [3:0] A,
    input [3:0] B,
    output LT
);assign LT = (A < B) ? 1'b1 : 1'b0;

endmodule