module top_module(
    input [1:0] A,
    input [1:0] B,
    input Cin,
    output [1:0] Sum,
    output Cout
);// Declare internal wires
wire [1:0] s;
wire c1, c2;

// First bit addition
assign s[0] = A[0] ^ B[0] ^ Cin;
assign c1 = (A[0] & B[0]) | (Cin & (A[0] ^ B[0]));

// Second bit addition
assign s[1] = A[1] ^ B[1] ^ c1;
assign c2 = (A[1] & B[1]) | (c1 & (A[1] ^ B[1]));

// Assign outputs
assign Sum = s;
assign Cout = c2;

endmodule