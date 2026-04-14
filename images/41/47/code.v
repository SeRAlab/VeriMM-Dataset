module top_module(
    input [3:0] in,
    input clk,           // Add clk input
    output reg [15:0] out
);reg [15:0] out_reg;

always @(*) begin
    out_reg = 16'b0;    // Initialize out_reg to zero
    out_reg[in] = 1'b1; // Use the in value to set the appropriate bit
end

always @(posedge clk) begin
    out <= out_reg;
end

endmodule