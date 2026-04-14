module two_bit_adder (
    input [1:0] A,
    input [1:0] B,
    input CI,
    output [1:0] Sum,
    output COUT_N
);

    wire [2:0] temp_sum;
    wire [1:0] temp_carry;

    assign temp_sum = {1'b0, A} + {1'b0, B} + {1'b0, CI};
    assign temp_carry = {temp_sum[2], temp_sum[1]};

    assign COUT_N = temp_sum[2];
    assign Sum = (temp_sum[1:0] >= 2'b10) ? (temp_sum[1:0] - 2'b10) : temp_sum[1:0];

endmodule