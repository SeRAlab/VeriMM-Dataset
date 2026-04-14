module register_8bit(
    input clk,          // Clock signal.
    input en,           // Load enable signal.
    input [7:0] d,      // 8-bit input data.
    output reg [7:0] q  // 8-bit output data.
);

// Register logic
always @(posedge clk) begin
    if (en) begin
        q <= d;
    end
end

endmodule