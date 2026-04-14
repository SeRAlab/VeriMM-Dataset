module four_bit_adder(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    wire [3:0] temp;
    wire carry;

    assign temp = A + B + Cin;
    assign Sum = temp[3:0];
    assign Cout = temp[4];

endmodule