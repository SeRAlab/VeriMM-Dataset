module counter_4bit(
    input clk,          // Clock signal.
    input en,           // Enable signal.
    output reg [3:0] q  // 4-bit counter output.
);

// Counter logic
always @(posedge clk) begin
    if (en)
        q <= q + 1;     // Increment counter if enable is active
end

endmodule