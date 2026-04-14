module top_module(
    input [3:0] DIN,
    input [1:0] SHIFT,
    input clk,           // Added clock input
    output reg [3:0] DOUT
);reg [3:0] stage1_out;
reg [3:0] stage2_out;
reg [3:0] stage3_out;

always @(*) begin
    stage1_out = DIN;  // Stage 1 output
end

always @(posedge clk) begin
    stage2_out <= stage1_out << 1;  // Shift left by 1 for stage 2
end

always @(posedge clk) begin
    stage3_out <= stage2_out << 1;  // Shift left by 1 for stage 3
end

always @(posedge clk) begin
    case(SHIFT)
        2'b00: DOUT <= stage1_out;         // No shift
        2'b01: DOUT <= stage2_out;         // Shift left by 1
        2'b10: DOUT <= stage3_out;         // Shift left by 2
        2'b11: DOUT <= {stage3_out[1:0], stage1_out[3:2]}; // Circular shift
    endcase
end

endmodule