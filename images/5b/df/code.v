module top_module(
    input [3:0] num,
    input clk,                    // Added clk input
    output reg [4:0] result
);reg [3:0] stage1_out;
reg [4:0] stage2_out;

always @(*) begin
    stage1_out = num + 1;
end

always @(posedge clk) begin
    stage2_out <= {1'b1, stage1_out[3:0]};
end

always @(posedge clk) begin
    result <= stage2_out + (stage2_out & (stage2_out - 1));
end

endmodule