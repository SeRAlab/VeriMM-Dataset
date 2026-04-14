module four_bit_adder (
    input [3:0] A,
    input [3:0] B,
    output [4:0] SUM,
    output OVERFLOW
);
    assign SUM = A + B;
    assign OVERFLOW = (SUM[4] ^ SUM[3]) | (A[3] & B[3]);
endmodule