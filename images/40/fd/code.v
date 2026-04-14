module multiplier_16bit (
    input [15:0] A,
    input [15:0] B,
    output [31:0] P
);
    assign P = A * B;
endmodule