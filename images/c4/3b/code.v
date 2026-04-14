module binary_adder (
    input [3:0] A,
    input [3:0] B,
    output [3:0] S,
    output C_out
);

    wire [4:0] temp_sum;
    wire temp_carry;

    assign temp_sum = A + B;
    assign temp_carry = temp_sum[4];

    assign S = (temp_carry) ? temp_sum[3:0] : temp_sum[2:0];
    assign C_out = temp_carry;

endmodule