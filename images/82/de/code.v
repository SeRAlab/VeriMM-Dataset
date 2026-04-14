module top_module(
    input [3:0] binary,
    input clk,  // Added clock input
    output reg [3:0] ones_comp
);reg [3:0] stage1_out;
reg [3:0] stage2_out;

// Pipeline stage 1
always @(*) begin
    stage1_out = ~binary;
end

// Pipeline stage 2
always @(*) begin
    stage2_out = ~stage1_out;
end

// Output stage
always @(posedge clk) begin
    ones_comp <= stage2_out;
end

endmodule