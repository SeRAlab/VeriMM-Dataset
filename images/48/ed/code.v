module divider_pipe_16bit
(
    input clk,
    input rst_n,
    input i_en,
    input [15:0] div_a,
    input [15:0] div_b,
    output [15:0] result,
    output reg o_en
);

reg stage1;
reg stage2;

reg [15:0] div_a_ff1;
reg [15:0] div_b_ff1;
reg [15:0] div_a_ff2;
reg [15:0] div_b_ff2;

reg [15:0] quotient1;
reg [15:0] quotient2;

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
        div_a_ff1 <= 16'd0;
        div_b_ff1 <= 16'd0;
        div_a_ff2 <= 16'd0;
        div_b_ff2 <= 16'd0;
    end else if (i_en) begin
        div_a_ff1 <= div_a;
        div_b_ff1 <= div_b;
        div_a_ff2 <= div_a_ff1;
        div_b_ff2 <= div_b_ff1;
    end
end

always @(posedge clk, negedge rst_n) begin
    if (!rst_n) begin
        quotient1 <= 16'd0;
        quotient2 <= 16'd0;
    end else if (stage1) begin
        quotient1 <= div_a_ff1 / div_b_ff1;
        quotient2 <= quotient1;
    end
end

assign result = quotient2;

endmodule