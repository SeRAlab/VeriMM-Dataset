module d_flip_flop(
    input clk,    // Chip clock signal.
    input rst_n,  // Active-low reset signal.
    input d,      // Input data signal.
    
    output reg q  // Output data signal.
);

//------------------------------------------------
// D flip-flop logic
always @(posedge clk or negedge rst_n)
    if (!rst_n) q <= 1'b0;  // Reset output
    else q <= d;            // Capture input

endmodule