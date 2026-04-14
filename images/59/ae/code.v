module top_module(
    input [31:0] A,
    input [31:0] B,
    output reg [32:0] Dif
);wire [31:0] G; // Generate signals
    wire [31:0] P; // Propagate signals
    wire [32:0] C; // Carry signals

    // Generate and Propagate calculations
    assign G = A & B;
    assign P = A ^ B;

    // Initial carry
    assign C[0] = 1'b0; // Assuming we are subtracting B from A without a borrow

    // Carry lookahead logic
    generate
        genvar i;
        for (i = 0; i < 32; i = i + 1) begin : carry_lookahead
            // Carry calculation
            assign C[i+1] = G[i] | (P[i] & C[i]);
        end
    endgenerate

    // Final output calculation
    assign Dif = {C[32], P ^ C[31:0]}; // Difference is P XOR Carry

endmodule