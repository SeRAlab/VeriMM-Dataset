module top_module(
    input [7:0] in,
    input clk,            // Added clk input as it was missing
    output reg [7:0] out
);reg [7:0] stage1_out;
reg [7:0] stage2_out;

// Stage 1: Invert the input using a constant value generator
always @(*) begin
    stage1_out = ~in;
end

// Stage 2: Add the inverted input to the original input on clock edge
always @(posedge clk) begin
    stage2_out <= stage1_out + in;
end

// Output the result
always @(posedge clk) begin
    out <= stage2_out;   // Updated to register output on clock edge
end

endmodule