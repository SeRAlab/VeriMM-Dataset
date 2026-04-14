module xnor_gate_pipe_20bit
(
    input clk,
    input rst_n,
    input i_en,
    input [19:0] xnor_a,
    input [19:0] xnor_b,
    output [19:0] result,
    output reg o_en
);

reg stage1;
reg stage2;

reg [19:0] xnor_a_ff1;
reg [19:0] xnor_b_ff1;
reg [19:0] xnor_a_ff2;
reg [19:0] xnor_b_ff2;

reg [19:0] xnor1;
reg [19:0] xnor2;

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
        xnor_a_ff1 <= 20'd0;
        xnor_b_ff1 <= 20'd0;
        xnor_a_ff2 <= 20'd0;
        xnor_b_ff2 <= 20'd0;
    end else if (i_en) begin
        xnor_a_ff1 <= xnor_a;
        xnor_b_ff1 <= xnor_b;
        xnor_a_ff2 <= xnor_a_ff1;
        xnor_b_ff2 <= xnor_b_ff1;
    end
end

always @(posedge clk, negedge rst_n) begin
    if (!rst_n) begin
        xnor1 <= 20'd0;
        xnor2 <= 20'd0;
    end else if (stage1) begin
        xnor1 <= ~(xnor_a_ff1 ^ xnor_b_ff1);
        xnor2 <= xnor1;
    end
end

assign result = xnor2;

endmodule