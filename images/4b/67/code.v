module top_module(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);wire [3:0] sum_wire;
    wire c1, c2, c3;

    assign sum_wire[0] = A[0] ^ B[0] ^ Cin;
    assign c1 = (A[0] & B[0]) | (A[0] & Cin) | (B[0] & Cin);
    assign sum_wire[1] = A[1] ^ B[1] ^ c1;
    assign c2 = (A[1] & B[1]) | (A[1] & c1) | (B[1] & c1);
    assign sum_wire[2] = A[2] ^ B[2] ^ c2;
    assign c3 = (A[2] & B[2]) | (A[2] & c2) | (B[2] & c2);
    assign sum_wire[3] = A[3] ^ B[3] ^ c3;
    assign Cout = (A[3] & B[3]) | (A[3] & c3) | (B[3] & c3);

    assign Sum = sum_wire;

endmodule