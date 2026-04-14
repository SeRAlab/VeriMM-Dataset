module multiplier_pipe_8bit
(
    input clk,
    input rst_n,
    input i_en,
    input [7:0] mul_a,
    input [7:0] mul_b,
    output [15:0] result,
    output reg o_en
);

reg stage1;
reg stage2;

reg [7:0] mul_a_ff1;
reg [7:0] mul_b_ff1;
reg [7:0] mul_a_ff2;
reg [7:0] mul_b_ff2;

reg [15:0] product1;
reg [15:0] product2;

always @(posedge clk, negedge rst_n) begin
    if (!rst_n) begin
        stage1 <= 1'b0;
        stage2 <= 1'b0;
        o_en <= 1'b0;
    end else begin
        stage1 <= i_en;
        stage2 <= stage1;
        o_en <= stage2;
    end
end

always @(posedge clk, negedge rst_n) begin
    if (!rst_n) begin
        mul_a_ff1 <= 8'd0;
        mul_b_ff1 <= 8'd0;
        mul_a_ff2 <= 8'd0;
        mul_b_ff2 <= 8'd0;
    end else if (i_en) begin
        mul_a_ff1 <= mul_a;
        mul_b_ff1 <= mul_b;
        mul_a_ff2 <= mul_a_ff1;
        mul_b_ff2 <= mul_b_ff1;
    end
end

always @(posedge clk, negedge rst_n) begin
    if (!rst_n) begin
        product1 <= 16'd0;
        product2 <= 16'd0;
    end else if (stage1) begin
        product1 <= mul_a_ff1 * mul_b_ff1;
        product2 <= product1;
    end
end

assign result = product2;

endmodule