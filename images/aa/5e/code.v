module top_module(
    input [3:0] A,
    input [3:0] B,
    output [3:0] sum,
    output carry_out
);wire [3:0] xor_out;
    wire [3:0] and_out;

    // XOR each bit of A and B to get the sum
    assign xor_out = A ^ B;

    // AND each bit of A and B to get the carry-out
    assign and_out = A & B;

    // Shift the carry-out to the left by 1 bit
    assign carry_out = {and_out, 1'b0};

    // Add the carry-out to the sum
    assign sum = xor_out + carry_out;

endmodule