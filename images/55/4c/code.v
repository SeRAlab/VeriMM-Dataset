module top_module(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    input Sel,
    output [3:0] S,
    output Cout
);wire [3:0] temp_sum;
    wire temp_carry;

    assign temp_sum = Sel ? A - B : A + B + Cin;
    assign S = temp_sum;
    assign Cout = Sel ? temp_sum[3] : temp_sum[4];

endmodule