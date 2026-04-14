module and_gate_pipe_8bit
(
    input clk,
    input rst_n,
    input i_en,
    input [7:0] and_a,
    input [7:0] and_b,
    output [7:0] result,
    output reg o_en
);

reg stage1;
reg stage2;

reg [7:0] and_a_ff1;
reg [7:0] and_b_ff1;
reg [7:0] and_a_ff2;
reg [7:0] and_b_ff2;

reg [7:0] and1;
reg [7:0] and2;

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
        and_a_ff1 <= 8'd0;
        and_b_ff1 <= 8'd0;
        and_a_ff2 <= 8'd0;
        and_b_ff2 <= 8'd0;
    end else if (i_en) begin
        and_a_ff1 <= and_a;
        and_b_ff1 <= and_b;
        and_a_ff2 <= and_a_ff1;
        and_b_ff2 <= and_b_ff1;
    end
end

always @(posedge clk, negedge rst_n) begin
    if (!rst_n) begin
        and1 <= 8'd0;
        and2 <= 8'd0;
    end else if (stage1) begin
        and1 <= and_a_ff1 & and_b_ff1;
        and2 <= and1;
    end
end

assign result = and2;

endmodule