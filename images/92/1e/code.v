module reg_8bit_en(
    input clk,          // Chip clock signal.
    input rst_n,        // Active-low reset signal. Defined as 0 for chip reset; defined as 1 for reset signal inactive.
    input en,           // Enable signal for data capture.
    input [7:0] d,      // 8-bit data input.

    output [7:0] q      // 8-bit data output.
);

reg [7:0] q_r; // Register to hold the data output.

// Register logic
always @(posedge clk or negedge rst_n) begin
    if (!rst_n)
        q_r <= 8'b00000000; // Reset register
    else if (en)
        q_r <= d; // Capture input data
end

assign q = q_r;

endmodule