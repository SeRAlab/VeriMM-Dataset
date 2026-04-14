module binary_counter_4bit(
    input clk,       // Clock input
    input reset,     // Synchronous reset input
    
    output [3:0] count  // 4-bit output representing the current count value
);

reg [3:0] count_r; // Register to hold the count value

always @(posedge clk) begin
    if (reset)
        count_r <= 4'b0000; // Reset the count to zero
    else
        count_r <= count_r + 1; // Increment the count
end

assign count = count_r;

endmodule