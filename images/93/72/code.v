module top_module(
    input clk,
    input a,
    input b,
    output reg out
);reg stage1, stage2;

always @(posedge clk) begin
    stage1 <= a ^ b;
    stage2 <= stage1;
    out <= stage1 ^ stage2;
end

endmodule