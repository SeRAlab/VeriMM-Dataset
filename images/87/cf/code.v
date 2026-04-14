module top_module(
    input clk,              // Added clk input
    input [7:0] D,
    output reg [7:0] R
);reg [7:0] stage1_out;
reg [7:0] stage2_out;

always @(posedge clk) begin
    stage1_out <= {D[6:0], D[7]};
end

always @(posedge clk) begin
    stage2_out <= {stage1_out[5:0], stage1_out[7:6]};
end

always @(posedge clk) begin
    R <= stage2_out;      // Changed to always block to update R on clk
end

endmodule