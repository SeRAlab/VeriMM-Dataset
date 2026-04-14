module four_bit_adder(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] S,
    output Cout
);

wire [3:0] X;
wire [3:0] Y;
wire [3:0] Z;

assign X = A ^ B;
assign Y = A & B;
assign Z = Cin & X;

assign S = X ^ Cin;
assign Cout = (Y | Z) | (X & Cin);

endmodule