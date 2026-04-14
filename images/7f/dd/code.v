module xor_gate_pipe_32bit
(
    input clk,
    input rst_n,
    input i_en,
    input [31:0] xor_a,
    input [31:0] xor_b,
    output [31:0] result,
    output reg o_en
);

reg stage1;
reg stage2;

reg [31:0] xor_a_ff1;
reg [31:0] xor_b_ff1;
reg [31:0] xor_a_ff2;
reg [31:0] xor_b_ff2;

reg [31:0] xor1;
reg [31:0] xor2;

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
        xor_a_ff1 <= 32'd0;
        xor_b_ff1 <= 32'd0;
        xor_a_ff2 <= 32'd0;
        xor_b_ff2 <= 32'd0;
    end else if (i_en) begin
        xor_a_ff1 <= xor_a;
        xor_b_ff1 <= xor_b;
        xor_a_ff2 <= xor_a_ff1;
        xor_b_ff2 <= xor_b_ff1;
    end
end

always @(posedge clk, negedge rst_n) begin
    if (!rst_n) begin
        xor1 <= 32'd0;
        xor2 <= 32'd0;
    end else if (stage1) begin
        xor1 <= xor_a_ff1 ^ xor_b_ff1;
        xor2 <= xor1;
    end
end

assign result = xor2;

endmodule