module top_module(
    input a,
    input b,
    input sel,
    input clk,          // Added clk input
    output reg out
);reg stage1_out;
reg stage2_out;

// Stage outputs are now registered outputs
always @(*) begin
    stage1_out = ~(a & sel);
    stage2_out = ~(b & ~sel);
end

always @(posedge clk) begin
    out <= stage2_out; // Outputs to the main output
end

endmodule