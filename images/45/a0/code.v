module top_module(
    input clk,             // Added clk input
    input [15:0] data_in,
    input [15:0] xor_key,
    output [15:0] data_out
);reg [15:0] stage1_out;
reg [15:0] stage2_out;
reg [15:0] stage3_out;

// Stage 1
always @ (posedge clk) begin
    stage1_out <= data_in ^ xor_key;
end

// Stage 2
always @ (posedge clk) begin
    stage2_out <= stage1_out;
end

// Stage 3
always @ (posedge clk) begin
    stage3_out <= stage2_out;
end

// Output
assign data_out = stage3_out;

endmodule