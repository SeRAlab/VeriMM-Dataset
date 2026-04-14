module top_module(
    input A1,
    input A2,
    input A3,
    input [1:0] B,
    output X
);assign X = (A1 == 1) && (A2 == 0) && (A3 == 1) && (B == 2'b10 || B == 2'b11);

endmodule