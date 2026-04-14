module top_module(
    input clk,    // Add the clk input
    input a,
    input b,
    output reg out
);reg stage1_out;
reg stage2_out;

always @(posedge clk) begin
    stage1_out <= a & b;
end

always @(posedge clk) begin
    stage2_out <= stage1_out;
end

always @(posedge clk) begin
    out <= stage2_out;
end

endmodule