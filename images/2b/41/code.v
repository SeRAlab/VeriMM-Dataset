module comparator_32bit (
    input [31:0] A,
    input [31:0] B,
    output reg A_gt_B,
    output reg A_lt_B,
    output reg A_eq_B
);
    always @(*) begin
        A_gt_B = (A > B);
        A_lt_B = (A < B);
        A_eq_B = (A == B);
    end
endmodule