module top_module(
    input clk,             // Added clk input
    input [0:0] in,
    output reg [2:0] out
);reg [2:0] stage1_out;
reg [2:0] stage2_out;

always @(posedge clk) begin
    stage1_out <= {stage1_out[1:0], in}; // Shift the input into stage1_out
end

always @(posedge clk) begin
    stage2_out <= stage1_out; // Pass data to stage2_out
end

always @(posedge clk) begin
    out <= stage2_out; // Update output
end

endmodule