module top_module(
    input [3:0] a,
    input [3:0] b,
    output reg eq,
    output reg gt_a,
    output reg gt_b
);always @(*) begin
        eq = (a == b);
        gt_a = (a > b);
        gt_b = (b > a);
    end

endmodule