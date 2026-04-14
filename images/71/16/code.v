module top_module(
    input A, B, C, D,
    input [1:0] sel,
    input clk,            // Added clk input
    output reg Y
);reg [1:0] stage1_sel;
reg [1:0] stage2_sel;

always @(*) begin
    stage1_sel = sel;
    stage2_sel = stage1_sel;
end

always @(posedge clk) begin
    case (stage2_sel)
        2'b00: Y <= A;
        2'b01: Y <= B;
        2'b10: Y <= C;
        2'b11: Y <= D;
        default: Y <= 1'b0; // Optional: Ensure Y is defined for all cases
    endcase
end

endmodule