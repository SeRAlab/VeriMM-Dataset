module top_module(
    input clk,            // Added clk input declaration
    input [3:0] in,
    output reg [1:0] pos
);reg [3:0] stage1_reg;
reg [2:0] stage2_reg;
reg [1:0] stage3_reg;

always @(posedge clk) begin
    stage1_reg <= in;
end

always @(posedge clk) begin
    stage2_reg[2] <= stage1_reg[3];
    stage2_reg[1] <= stage1_reg[2] | stage2_reg[2];
    stage2_reg[0] <= stage1_reg[1] | stage2_reg[1];
end

always @(posedge clk) begin
    stage3_reg[1] <= stage2_reg[2] | stage2_reg[1] | stage2_reg[0];
    stage3_reg[0] <= stage2_reg[1] | stage2_reg[0];
end

always @(posedge clk) begin
    if (stage3_reg[1]) begin
        pos <= 2'b11;
    end else if (stage3_reg[0]) begin
        pos <= 2'b10;
    end else begin
        pos <= 2'b00;
    end
end

endmodule