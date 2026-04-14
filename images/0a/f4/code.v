module comparator_8bit (
    input [7:0] A,
    input [7:0] B,
    output reg A_eq_B,
    output reg A_gt_B,
    output reg A_lt_B
);

always @(*) begin
    A_eq_B = (A == B);
    A_gt_B = (A > B);
    A_lt_B = (A < B);
end

endmodule