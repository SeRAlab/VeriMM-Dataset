module sync_counter(
    input clk,          // Clock signal.
    input rst_n,        // Active-low reset signal. Defined as 0 for reset.
    input en,           // Enable signal to allow counting.
    output [3:0] count  // 4-bit output representing the current counter value.
);

reg [3:0] count_r;  // Counter register.

// Synchronous reset and count logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) 
        count_r <= 4'b0000;  // Reset counter to zero
    else if (en)
        count_r <= count_r + 1'b1;  // Increment counter
end

assign count = count_r;

endmodule