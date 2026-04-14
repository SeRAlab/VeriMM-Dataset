module and_gate_pipe_4bit
(
    input clk,
    input rst_n,
    input i_en,
    input [3:0] and_a,
    input [3:0] and_b,
    output [3:0] result,
    output reg o_en
);

reg stage1;
reg stage2;
reg stage3;

reg [3:0] and_a_ff1;
reg [3:0] and_b_ff1;
reg [3:0] and_a_ff2;
reg [3:0] and_b_ff2;
reg [3:0] and_a_ff3;
reg [3:0] and_b_ff3;

reg [3:0] and1;
reg [3:0] and2;
reg [3:0] and3;

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
        and_a_ff1 <= 4'd0;
        and_b_ff1 <= 4'd0;
        and_a_ff2 <= 4'd0;
        and_b_ff2 <= 4'd0;
        and_a_ff3 <= 4'd0;
        and_b_ff3 <= 4'd0;
    end else if (i_en) begin
        and_a_ff1 <= and_a;
        and_b_ff1 <= and_b;
        and_a_ff2 <= and_a_ff1;
        and_b_ff2 <= and_b_ff1;
        and_a_ff3 <= and_a_ff2;
        and_b_ff3 <= and_b_ff2;
    end
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        and1 <= 4'd0;
        and2 <= 4'd0;
        and3 <= 4'd0;
    end else if (stage1) begin
        and1 <= and_a_ff1 & and_b_ff1;
        and2 <= and1;
        and3 <= and2;
    end
end

assign result = and3;

endmodule