module up_down_counter_4bit(
    input clk,          // Chip clock signal.
    input rst_n,        // Active-low reset signal. Defined as 0 for chip reset; defined as 1 for reset signal inactive.
    input up_dn,        // Control signal to determine counting direction.

    output [3:0] count  // 4-bit count value.
);

reg [3:0] count_r; // Register to hold the count value.

// Counter logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        count_r <= 4'b0000; // Reset counter
    else if (up_dn)
        count_r <= count_r + 1'b1; // Increment counter
    else
        count_r <= count_r - 1'b1; // Decrement counter
end

assign count = count_r;

endmodule