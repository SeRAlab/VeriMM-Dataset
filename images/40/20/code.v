module multiplier_64x64 (
    input [63:0] A,
    input [63:0] B,
    output [127:0] P
);
    assign P = A * B;
endmodule