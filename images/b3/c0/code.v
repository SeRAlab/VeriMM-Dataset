module top_module(
    // Inputs
    input [3:0] a,
    input [3:0] b,
    // Outputs
    output [4:0] sum
);// Internal wires
    wire [3:0] carry_out;
    wire [3:0] sum_internal;

    // Generate the sum for each bit
    assign sum_internal[0] = a[0] ^ b[0];
    assign sum_internal[1] = a[1] ^ b[1] ^ carry_out[0];
    assign sum_internal[2] = a[2] ^ b[2] ^ carry_out[1];
    assign sum_internal[3] = a[3] ^ b[3] ^ carry_out[2];

    // Generate the carry out for each bit
    assign carry_out[0] = (a[0] & b[0]) | (a[0] & carry_out[0]) | (b[0] & carry_out[0]);
    assign carry_out[1] = (a[1] & b[1]) | (a[1] & carry_out[1]) | (b[1] & carry_out[1]);
    assign carry_out[2] = (a[2] & b[2]) | (a[2] & carry_out[2]) | (b[2] & carry_out[2]);
    assign carry_out[3] = (a[3] & b[3]) | (a[3] & carry_out[3]) | (b[3] & carry_out[3]);

    // Assign the output
    assign sum = {carry_out[3], sum_internal};

endmodule