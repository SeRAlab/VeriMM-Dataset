module multiplier_2bit (
    input [1:0] A,
    input [1:0] B,
    output [3:0] P
);
    assign P = A * B; // 2-bit multiplier producing a 4-bit result
endmodule