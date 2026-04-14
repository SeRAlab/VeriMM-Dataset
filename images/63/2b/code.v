module nor_gate_pipe_4bit
(
    input clk,
    input rst_n,
    input i_en,
    input [3:0] nor_a,
    input [3:0] nor_b,
    output [3:0] result,
    output reg o_en
);

reg stage1;
reg stage2;

reg [3:0] nor_a_ff1;
reg [3:0] nor_b_ff1;
reg [3:0] nor_a_ff2;
reg [3:0] nor_b_ff2;

reg [3:0] nor1;
reg [3:0] nor2;

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
        nor_a_ff1 <= 4'd0;
        nor_b_ff1 <= 4'd0;
        nor_a_ff2 <= 4'd0;
        nor_b_ff2 <= 4'd0;
    end else if (i_en) begin
        nor_a_ff1 <= nor_a;
        nor_b_ff1 <= nor_b;
        nor_a_ff2 <= nor_a_ff1;
        nor_b_ff2 <= nor_b_ff1;
    end
end

always @(posedge clk, negedge rst_n) begin
    if (!rst_n) begin
        nor1 <= 4'd0;
        nor2 <= 4'd0;
    end else if (stage1) begin
        nor1 <= ~(nor_a_ff1 | nor_b_ff1);
        nor2 <= nor1;
    end
end

assign result = nor2;

endmodule