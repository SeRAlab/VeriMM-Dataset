module top_module(
    input clk,
    input rst,
    input [15:0] arg_0,
    input [15:0] arg_1,
    input is_sub,
    output reg [15:0] ret_0, // Changed to reg
    output reg [15:0] ret_1, // Changed to reg
    output reg ret_2,        // Changed to reg
    output reg ret_3         // Changed to reg
);wire [15:0] x;
    wire [15:0] y;
    wire        ys;
    wire        yys;
    wire [15:0] yy;
    wire        diff_sign;
    wire [4:0]  xe;
    wire [4:0]  ye;
    wire        swap;
    wire        neg_lhs;
    wire        neg_rhs;
    wire [15:0] lhs;
    wire [15:0] rhs;
    wire [16:0] sum;
    
    assign x = arg_0;
    assign y = arg_1;
    assign ys = y[15];
    assign yys = is_sub ? ~ys : ys;
    assign yy = {yys, y[14:0]};
    assign xe = x[14:10];
    assign ye = y[14:10];
    
    assign diff_sign = x[15] ^ yy[15];
    
    assign swap = xe < ye;
    assign lhs = swap ? yy : x;
    assign rhs = swap ? x : yy;
    
    assign neg_lhs = diff_sign ? lhs[15] : 0;
    assign neg_rhs = diff_sign ? rhs[15] : 0;
    
    assign sum = {1'b0, lhs} + {neg_rhs, rhs};
    
    always @(posedge clk) begin
        if (rst) begin
            ret_0 <= 16'b0;
            ret_1 <= 16'b0;
            ret_2 <= 1'b0;
            ret_3 <= 1'b0;
        end else begin
            if (is_sub) begin
                ret_0 <= lhs;
                ret_1 <= rhs;
                ret_2 <= neg_lhs;
                ret_3 <= neg_rhs;
            end else begin
                ret_0 <= sum[15:0];
                ret_1 <= sum[15:0];
                ret_2 <= sum[16];
                ret_3 <= 1'b0;
            end
        end
    end
endmodule