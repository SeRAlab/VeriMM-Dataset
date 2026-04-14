module subtractor_pipe_4bit
(
    input clk,
    input rst_n,
    input i_en,
    input [3:0] sub_a,
    input [3:0] sub_b,
    output [3:0] result,
    output reg o_en
);

reg stage1;
reg stage2;

reg [3:0] sub_a_ff1;
reg [3:0] sub_b_ff1;
reg [3:0] sub_a_ff2;
reg [3:0] sub_b_ff2;

reg [3:0] diff1;
reg [3:0] diff2;

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
        sub_a_ff1 <= 4'd0;
        sub_b_ff1 <= 4'd0;
        sub_a_ff2 <= 4'd0;
        sub_b_ff2 <= 4'd0;
    end else if (i_en) begin
        sub_a_ff1 <= sub_a;
        sub_b_ff1 <= sub_b;
        sub_a_ff2 <= sub_a_ff1;
        sub_b_ff2 <= sub_b_ff1;
    end
end

always @(posedge clk, negedge rst_n) begin
    if (!rst_n) begin
        diff1 <= 4'd0;
        diff2 <= 4'd0;
    end else if (stage1) begin
        diff1 <= sub_a_ff1 - sub_b_ff1;
        diff2 <= diff1;
    end
end

assign result = diff2;

endmodule