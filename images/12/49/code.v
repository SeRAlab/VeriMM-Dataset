module adder_32bit(
    input [31:0] A,
    input [31:0] B,
    output [31:0] SUM,
    output OVERFLOW
);
    wire [32:0] temp_sum;

    assign temp_sum = {1'b0, A} + {1'b0, B}; // Extend A and B to 33 bits for overflow checking
    assign SUM = temp_sum[31:0]; // Take the lower 32 bits as the sum
    assign OVERFLOW = temp_sum[32]; // The 33rd bit indicates overflow

endmodule