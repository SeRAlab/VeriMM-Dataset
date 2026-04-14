module or_gate_pipe_64bit
(
    input clk,
    input rst_n,
    input i_en,
    input [63:0] or_a,
    input [63:0] or_b,
    output [63:0] result,
    output reg o_en
);

reg stage1;
reg stage2;
reg stage3;

reg [63:0] or_a_ff1;
reg [63:0] or_b_ff1;
reg [63:0] or_a_ff2;
reg [63:0] or_b_ff2;
reg [63:0] or_a_ff3;
reg [63:0] or_b_ff3;

reg [63:0] or1;
reg [63:0] or2;
reg [63:0] or3;

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        stage1 <= 1'b0;
        stage2 <= 1'b0;
        stage3 <= 1'b0;
        o_en <= 1'b0;
    end else begin
        stage1 <= i_en;
        stage2 <= stage1;
        stage3 <= stage2;
        o_en <= stage3;
    end
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        or_a_ff1 <= 64'd0;
        or_b_ff1 <= 64'd0;
        or_a_ff2 <= 64'd0;
        or_b_ff2 <= 64'd0;
        or_a_ff3 <= 64'd0;
        or_b_ff3 <= 64'd0;
    end else if (i_en) begin
        or_a_ff1 <= or_a;
        or_b_ff1 <= or_b;
        or_a_ff2 <= or_a_ff1;
        or_b_ff2 <= or_b_ff1;
        or_a_ff3 <= or_a_ff2;
        or_b_ff3 <= or_b_ff2;
    end
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        or1 <= 64'd0;
        or2 <= 64'd0;
        or3 <= 64'd0;
    end else if (stage1) begin
        or1 <= or_a_ff1 | or_b_ff1;
        or2 <= or1;
        or3 <= or2;
    end
end

assign result = or3;

endmodule