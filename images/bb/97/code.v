module d_flip_flop(
    input clk,          // Clock signal.
    input reset,        // Asynchronous reset signal.
    input d,            // Data input.
    output reg q        // Data output.
);

// D flip-flop logic with asynchronous reset
always @(posedge clk or posedge reset) begin
    if (reset)
        q <= 1'b0;      // Reset output to 0
    else
        q <= d;         // Transfer data input to output
end

endmodule