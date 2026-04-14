module multiplier_pipe_32bit
#(
    parameter DATA_WIDTH = 32,
    parameter STG_WIDTH = 16
)
(
    input clk,
    input rst_n,
    input i_en,
    input [DATA_WIDTH-1:0] mul_a,
    input [DATA_WIDTH-1:0] mul_b,
    output [DATA_WIDTH*2-1:0] result,
    output reg o_en
);

reg stage1;
reg stage2;
reg stage3;

reg [DATA_WIDTH-1:0] mul_a_ff1;
reg [DATA_WIDTH-1:0] mul_b_ff1;
reg [DATA_WIDTH-1:0] mul_a_ff2;
reg [DATA_WIDTH-1:0] mul_b_ff2;

reg [DATA_WIDTH*2-1:0] p1;
reg [DATA_WIDTH*2-1:0] p2;
reg [DATA_WIDTH*2-1:0] p3;

always @(posedge clk, negedge rst_n) begin
    if (!rst_n) begin
        stage1 <= 1'b0;
        stage2 <= 1'b0;
        stage3 <= 1'b0;
        o_en <= 1'b0;
    end
    else begin
        stage1 <= i_en;
        stage2 <= stage1;
        stage3 <= stage2;
        o_en <= stage3;
    end
end

always @(posedge clk, negedge rst_n) begin
    if (!rst_n) begin
        mul_a_ff1 <= 'd0;
        mul_b_ff1 <= 'd0;
        mul_a_ff2 <= 'd0;
        mul_b_ff2 <= 'd0;
    end
    else if (i_en) begin
        mul_a_ff1 <= mul_a;
        mul_b_ff1 <= mul_b;
        mul_a_ff2 <= mul_a_ff1;
        mul_b_ff2 <= mul_b_ff1;
    end
end

always @(posedge clk, negedge rst_n) begin
    if (!rst_n) begin
        p1 <= 'd0;
    end
    else if (stage1) begin
        p1 <= mul_a_ff1 * mul_b_ff1;
    end
end

always @(posedge clk, negedge rst_n) begin
    if (!rst_n) begin
        p2 <= 'd0;
    end
    else if (stage2) begin
        p2 <= p1;
    end
end

always @(posedge clk, negedge rst_n) begin
    if (!rst_n) begin
        p3 <= 'd0;
    end
    else if (stage3) begin
        p3 <= p2;
    end
end

assign result = p3;

endmodule