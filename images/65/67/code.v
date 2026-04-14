module top_module(
    input [3:0] a,
    input [3:0] b,
    input carry_in,
    output [3:0] sum,
    output carry_out
);

    // Intermediate full adder sum and carry outputs
    wire [4:0] temp_sum;

    // Perform addition with carry-in
    assign temp_sum = a + b + carry_in;

    // Assign the sum and carry-out
    assign sum = temp_sum[3:0];
    assign carry_out = temp_sum[4];

endmodule