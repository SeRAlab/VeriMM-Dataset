module top_module(
    input clk,         // Added clk input
    input [1:0] MODE,
    input [1:0] SEL,
    input EN,
    output reg [3:0] Y
);reg [1:0] stage1_SEL;
reg [1:0] stage2_SEL;
reg [1:0] stage3_SEL;

always @(posedge clk) begin
    stage1_SEL <= SEL;
    stage2_SEL <= stage1_SEL;
    stage3_SEL <= stage2_SEL;
end

always @(*) begin
    if (!EN) begin  // Adjusted logic for enable
        Y <= 4'b0000;
    end else begin
        case (MODE)
            2'b00: Y <= {~SEL[1], ~SEL[0], SEL[1], SEL[0]};
            2'b01: Y <= {stage3_SEL[1] & 2'b10, stage3_SEL[0] & 2'b10, 2'b00, 2'b00};
            2'b10: Y <= {stage3_SEL[1] | 2'b01, stage3_SEL[0] | 2'b01, 2'b11, 2'b11};
            default: Y <= 4'b0000;
        endcase
    end
end

endmodule