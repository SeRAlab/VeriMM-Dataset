module top_module(
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] Sum,
    output Cout
);wire [3:0] temp_sum;
    wire [3:0] temp_carry;

    assign temp_sum = A + B + Cin;
    assign Sum = temp_sum[3:0];
    assign Cout = temp_sum[4] | (temp_sum[3] & (temp_sum[2] | temp_sum[1] | temp_sum[0]));

endmodule