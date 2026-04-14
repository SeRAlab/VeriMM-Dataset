module top_module(
    input [3:0] A, B, C, D,
    input Cin,
    output [3:0] Sum,
    output Cout
);wire [3:0] S1, S2, S3;
wire C1, C2, C3;

assign S1 = A + B;
assign S2 = S1 + C;
assign S3 = S2 + D;

assign Cout = C3;
assign Sum = S3;

endmodule