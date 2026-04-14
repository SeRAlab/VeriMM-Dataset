module d_flip_flop(
    input clk,      // Clock input
    input reset,    // Asynchronous reset input
    input d,        // Data input
    
    output reg q    // Data output
);

always @(posedge clk or posedge reset) begin
    if (reset)
        q <= 1'b0; // Reset the output to zero
    else
        q <= d;    // Capture the input data on rising edge of clock
end

endmodule