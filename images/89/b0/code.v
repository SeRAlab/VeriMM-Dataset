module or_gate_pipe_12bit
(
    input clk,
    input rst_n,
    input i_en,
    input [11:0] or_a,
    input [11:0] or_b,
    output [11:0] result,
    output reg o_en
);

reg stage1;
reg stage2;

reg [11:0] or_a_ff1;
reg [11:0] or_b_ff1;
reg [11:0] or_a_ff2;
reg [11:0] or_b_ff2;

reg [11:0] or1;
reg [11:0] or2;

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
        or_a_ff1 <= 12'd0;
        or_b_ff1 <= 12'd0;
        or_a_ff2 <= 12'd0;
        or_b_ff2 <= 12'd0;
    end else if (i_en) begin
        or_a_ff1 <= or_a;
        or_b_ff1 <= or_b;
        or_a_ff2 <= or_a_ff1;
        or_b_ff2 <= or_b_ff1;
    end
end

always @(posedge clk, negedge rst_n) begin
    if (!rst_n) begin
        or1 <= 12'd0;
        or2 <= 12'd0;
    end else if (stage1) begin
        or1 <= or_a_ff1 | or_b_ff1;
        or2 <= or1;
    end
end

assign result = or2;

endmodule