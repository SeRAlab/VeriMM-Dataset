module adder4(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

wire [3:0] xor_out;
wire [3:0] and_out;
wire [3:0] or_out;

// Generate sum bits
assign xor_out = A ^ B;
assign Sum = xor_out ^ Cin;

// Generate carry out
assign and_out = A & B;
assign or_out = A | B;
assign Cout = (and_out | (xor_out & Cin)) | (or_out & Cin);

endmodule