module multiplier_16x16 (
    input [15:0] A,
    input [15:0] B,
    output [31:0] P
);
    assign P = A * B;
endmodule