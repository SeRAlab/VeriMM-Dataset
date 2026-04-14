module d_flip_flop(
    input clk,          // Chip clock signal.
    input rst_n,        // Active-low asynchronous reset signal.
    input d,            // Data input.

    output q            // Data output.
);

reg q_r;

always @(posedge clk or negedge rst_n)
    if (!rst_n)
        q_r <= 1'b0; // Reset output to 0
    else
        q_r <= d; // Capture data input on rising edge of clock

assign q = q_r;

endmodule