module top_module(
    input [1:0] D,
    input clk, // Added clk as an input
    output reg [2:0] C
);reg [1:0] stage1_output;
reg [2:0] stage2_output;

always @ (posedge clk) begin
    stage1_output <= D;
end

always @ (posedge clk) begin
    stage2_output <= {1'b0, stage1_output};
end

assign C = stage2_output;

endmodule