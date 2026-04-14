module top_module(
    input clk,           // Added clock input
    input [3:0] binary,
    output reg [7:0] bcd
);reg [3:0] stage1_out;
reg [3:0] stage2_out;
reg [3:0] stage3_out;

always @(*) begin
    stage1_out = binary;
end

always @(posedge clk) begin
    stage2_out <= stage1_out + (stage1_out >= 5 ? 3 : 0);
    stage3_out <= stage2_out + (stage2_out >= 10 ? 6 : 0);
    bcd <= {stage3_out[3:0], stage2_out[3:0]};  // Corrected the concatenation order
end

endmodule