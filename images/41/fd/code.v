module top_module(
    input [7:0] A,
    input [7:0] B,
    input CI,
    output [8:0] SUM,
    output COUT_N
);wire [7:0] temp_sum;
    wire temp_carry;

    // Add A and B
    assign temp_sum = A + B;

    // If CI is high, add 1 to the sum
    assign temp_sum = (CI == 1'b1) ? temp_sum + 1 : temp_sum;

    // Check if there is a carry-out
    assign temp_carry = (CI == 1'b1) ? (temp_sum[8] | A[7] | B[7]) : (temp_sum[8] & A[7] & B[7]);

    // Output the sum and carry-out
    assign SUM = temp_sum;
    assign COUT_N = ~temp_carry;

endmodule