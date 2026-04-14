module four_bit_adder (
    input [3:0] A,
    input [3:0] B,
    input Cin,
    output [3:0] S
);

    wire [4:0] temp_sum;

    assign temp_sum = A + B + Cin;

    assign S = temp_sum[3:0];

endmodule