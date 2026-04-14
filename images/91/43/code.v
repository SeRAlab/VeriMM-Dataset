module reg_8bit(
    input clk,        // Clock signal
    input en,         // Enable signal
    input [7:0] d,    // 8-bit data input
    output reg [7:0] q // 8-bit data output
);

// Register logic with enable
always @(posedge clk) begin
    if (en)
        q <= d;       // Capture data if enabled
end

endmodule