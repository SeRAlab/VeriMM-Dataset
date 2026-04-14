module adder_pipe_16bit
(
    input clk,
    input rst_n,
    input i_en,
    input [15:0] add_a,
    input [15:0] add_b,
    output [15:0] result,
    output reg o_en
);

reg stage1;
reg stage2;

reg [15:0] add_a_ff1;
reg [15:0] add_b_ff1;
reg [15:0] add_a_ff2;
reg [15:0] add_b_ff2;

reg [15:0] sum1;
reg [15:0] sum2;

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
        add_a_ff1 <= 16'd0;
        add_b_ff1 <= 16'd0;
        add_a_ff2 <= 16'd0;
        add_b_ff2 <= 16'd0;
    end else if (i_en) begin
        add_a_ff1 <= add_a;
        add_b_ff1 <= add_b;
        add_a_ff2 <= add_a_ff1;
        add_b_ff2 <= add_b_ff1;
    end
end

always @(posedge clk, negedge rst_n) begin
    if (!rst_n) begin
        sum1 <= 16'd0;
        sum2 <= 16'd0;
    end else if (stage1) begin
        sum1 <= add_a_ff1 + add_b_ff1;
        sum2 <= sum1;
    end
end

assign result = sum2;

endmodule