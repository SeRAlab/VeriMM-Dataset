module top_module(
    input [63:0] A,
    input [63:0] B,
    input [15:0] C,
    input [15:0] D,
    input [15:0] E,
    input [15:0] F,
    input [1:0] SEL,
    output [63:0] Y
);wire [15:0] row0, row1, row2, row3;
    wire [15:0] col0, col1, col2, col3;

    // Matrix multiplication
    assign row0 = A[15:0]*B[0] + A[31:16]*B[4] + A[47:32]*B[8] + A[63:48]*B[12];
    assign row1 = A[15:0]*B[1] + A[31:16]*B[5] + A[47:32]*B[9] + A[63:48]*B[13];
    assign row2 = A[15:0]*B[2] + A[31:16]*B[6] + A[47:32]*B[10] + A[63:48]*B[14];
    assign row3 = A[15:0]*B[3] + A[31:16]*B[7] + A[47:32]*B[11] + A[63:48]*B[15];

    // Vector addition
    assign col0 = (SEL == 2'b01) ? C : (SEL == 2'b10) ? D : (SEL == 2'b11) ? E + F : row0[15:0];
    assign col1 = (SEL == 2'b01) ? C : (SEL == 2'b10) ? D : (SEL == 2'b11) ? E + F : row1[15:0];
    assign col2 = (SEL == 2'b01) ? C : (SEL == 2'b10) ? D : (SEL == 2'b11) ? E + F : row2[15:0];
    assign col3 = (SEL == 2'b01) ? C : (SEL == 2'b10) ? D : (SEL == 2'b11) ? E + F : row3[15:0];

    // Output
    assign Y = {col0, col1, col2, col3};

endmodule