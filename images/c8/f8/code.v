module adder4(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] S,
    output Cout
);
    wire [3:0] sum;
    wire carry;

    assign sum = A + B + Cin;

    assign S = sum[3:0];
    assign Cout = sum[4];

endmodule