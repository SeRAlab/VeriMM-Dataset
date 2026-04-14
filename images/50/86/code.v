module top_module(
    input [3:0] a, b,
    input carry_in,
    output [3:0] sum,
    output carry_out
);wire [3:0] temp_sum;
    wire [3:0] temp_carry;

    assign temp_sum = a + b + carry_in;
    assign sum = temp_sum[3:0];
    assign carry_out = temp_sum[4] | temp_carry[3];

    genvar i;
    generate
        for (i = 0; i < 3; i = i + 1) begin : carry_gen
            assign temp_carry[i] = temp_sum[i+1] & temp_carry[i+1];
        end
    endgenerate

endmodule