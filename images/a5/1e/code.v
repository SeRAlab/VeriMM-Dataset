module comparator(
    input [3:0] a,
    input [3:0] b,
    
    output reg a_gt_b,
    output reg a_eq_b,
    output reg a_lt_b
);
    always @(*) begin
        if (a > b) begin
            a_gt_b <= 1;
            a_eq_b <= 0;
            a_lt_b <= 0;
        end else if (a == b) begin
            a_gt_b <= 0;
            a_eq_b <= 1;
            a_lt_b <= 0;
        end else begin
            a_gt_b <= 0;
            a_eq_b <= 0;
            a_lt_b <= 1;
        end
    end
endmodule