module fourBitAdder(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);

    wire [3:0] temp_sum;
    wire temp_cout;

    assign temp_sum = A + B + Cin;
    assign Sum = temp_sum[3:0];
    assign Cout = temp_sum[4];

endmodule