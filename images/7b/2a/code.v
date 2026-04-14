module top_module(
    input A,
    input B,
    input C,
    input D,
    input SEL1,
    input SEL2,
    input EN,
    input clk, // Added clk input here
    output reg OUT
);reg [1:0] stage1_sel;
reg [1:0] stage2_sel;
reg [1:0] stage3_sel;

wire stage1_out_A;
wire stage1_out_B;
wire stage1_out_C;
wire stage1_out_D;

wire stage2_out_A;
wire stage2_out_B;

wire stage3_out;

assign stage1_out_A = (SEL1 & ~SEL2) ? A : 1'b0;
assign stage1_out_B = (~SEL1 & ~SEL2) ? B : 1'b0;
assign stage1_out_C = (SEL1 & SEL2) ? C : 1'b0;
assign stage1_out_D = (~SEL1 & SEL2) ? D : 1'b0;

assign stage2_out_A = (stage1_sel[1] & ~stage1_sel[0]) ? stage1_out_A : 1'b0;
assign stage2_out_B = (~stage1_sel[1] & ~stage1_sel[0]) ? stage1_out_B : 1'b0;

assign stage3_out = (stage2_sel[1] & ~stage2_sel[0]) ? stage2_out_A : stage2_out_B;

always @(posedge clk) begin
    if (EN) begin
        stage1_sel <= {SEL2, SEL1};
        stage2_sel <= stage1_sel;
        stage3_sel <= stage2_sel;
        OUT <= stage3_out;
    end
end

endmodule