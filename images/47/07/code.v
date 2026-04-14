module d_flip_flop(
    input clk,       // Chip clock signal.
    input reset,     // Asynchronous reset signal.
    input d,         // Input data.
    output q         // Flip-flop output signal.
);

reg q_reg;           // Flip-flop register.

always @(posedge clk or posedge reset)
    if (reset) q_reg <= 1'b0;                      // Reset to zero if reset is active.
    else q_reg <= d;                               // Capture input data otherwise.

assign q = q_reg;                                  // Output flip-flop value.

endmodule