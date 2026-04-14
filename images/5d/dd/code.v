module or_pipe_32bit
(
    input clk,
    input rst_n,
    input i_en,
    input [31:0] or_a,
    input [31:0] or_b,
    output [31:0] result,
    output reg o_en
);

reg stage1;
reg stage2;

reg [31:0] or_a_ff1;
reg [31:0] or_b_ff1;
reg [31:0] or_a_ff2;
reg [31:0] or_b_ff2;

reg [31:0] or_result1;
reg [31:0] or_result2;

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
        or_a_ff1 <= 32'd0;
        or_b_ff1 <= 32'd0;
        or_a_ff2 <= 32'd0;
        or_b_ff2 <= 32'd0;
    end else if (i_en) begin
        or_a_ff1 <= or_a;
        or_b_ff1 <= or_b;
        or_a_ff2 <= or_a_ff1;
        or_b_ff2 <= or_b_ff1;
    end
end

always @(posedge clk, negedge rst_n) begin
    if (!rst_n) begin
        or_result1 <= 32'd0;
        or_result2 <= 32'd0;
    end else if (stage1) begin
        or_result1 <= or_a_ff1 | or_b_ff1;
        or_result2 <= or_result1;
    end
end

assign result = or_result2;

endmodule