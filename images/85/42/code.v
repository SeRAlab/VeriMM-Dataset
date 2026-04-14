module top_module(
    input [3:0] in,
    input clk,          // Added clk input
    output reg [1:0] out
);reg [1:0] stage1_out;
reg [1:0] stage2_out;

// Stage 1
always @(*) begin
    if (in[3]) stage1_out = 2'b11; // Highest priority first
    else if (in[2]) stage1_out = 2'b10;
    else if (in[1]) stage1_out = 2'b01;
    else if (in[0]) stage1_out = 2'b00;
    else stage1_out = 2'b00; // Default case (no input)
end

// Stage 2
always @(posedge clk) begin
    stage2_out <= stage1_out;
end

// Output
always @(*) begin
    out = stage2_out;
end

endmodule