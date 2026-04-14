module counter_4bit(
    input clk,          // Chip clock signal.
    input rst_n,        // Active-low reset signal. Defined as 0 for chip reset; defined as 1 for reset signal inactive.
    input en,           // Enable signal to allow counting.
    input load,         // Load signal to load the counter with a specific value.
    input [3:0] d,      // 4-bit load value.

    output [3:0] q      // 4-bit count value.
);

reg [3:0] q_r; // Count register.

//------------------------------------------------
// Counter operation
always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        q_r <= 4'b0;
    end
    else if (load) begin
        q_r <= d; // Load the counter with the input value.
    end
    else if (en) begin
        q_r <= q_r + 1'b1; // Increment the counter.
    end
end

assign q = q_r;

endmodule