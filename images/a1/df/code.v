module subtractor_pipe_8bit
(
    input clk,
    input rst_n,
    input i_en,
    input [7:0] sub_a,
    input [7:0] sub_b,
    output [7:0] result,
    output reg o_en
);

reg stage1;
reg stage2;
reg stage3;

reg [7:0] sub_a_ff1;
reg [7:0] sub_b_ff1;
reg [7:0] sub_a_ff2;
reg [7:0] sub_b_ff2;
reg [7:0] sub_a_ff3;
reg [7:0] sub_b_ff3;

reg [7:0] diff1;
reg [7:8] diff2;
reg [7:8] diff3;

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
        sub_a_ff1 <= 8'd0;
        sub_b_ff1 <= 8'd0;
        sub_a_ff2 <= 8'd0;
        sub_b_ff2 <= 8'd0;
        sub_a_ff3 <= 8'd0;
        sub_b_ff3 <= 8'd0;
    end else if (i_en) begin
        sub_a_ff1 <= sub_a;
        sub_b_ff1 <= sub_b;
        sub_a_ff2 <= sub_a_ff1;
        sub_b_ff2 <= sub_b_ff1;
        sub_a_ff3 <= sub_a_ff2;
        sub_b_ff3 <= sub_b_ff2;
    end
end

always @(posedge clk or negedge rst_n) begin
    if (!rst_n) begin
        diff1 <= 8'd0;
        diff2 <= 8'd0;
        diff3 <= 8'd0;
    end else if (stage1) begin
        diff1 <= sub_a_ff1 - sub_b_ff1;
        diff2 <= diff1;
        diff3 <= diff2;
    end
end

assign result = diff3;

endmodule