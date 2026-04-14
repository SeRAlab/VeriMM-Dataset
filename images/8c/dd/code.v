module up_down_counter_3bit(
    input clk,          // Chip clock signal.
    input rst_n,        // Active-low reset signal. Defined as 0 for chip reset; defined as 1 for reset signal inactive.
    input up_down,      // Control signal. Defined as 1 for count up; defined as 0 for count down.

    output [2:0] count  // 3-bit count value.
);

reg [2:0] count_r; // Register to hold the count value.

// Counter logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        count_r <= 3'b000; // Reset counter
    else if (up_down)
        count_r <= count_r + 1'b1; // Increment counter
    else
        count_r <= count_r - 1'b1; // Decrement counter
end

assign count = count_r;

endmodule