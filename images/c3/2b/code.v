module four_bit_adder(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] S,
    output Cout
);

wire [3:0] sum;
wire [3:0] carry;

assign sum = A + B + Cin;
assign carry = ((A & B) | (A & Cin) | (B & Cin));

assign S = sum;
assign Cout = carry[3];

endmodule