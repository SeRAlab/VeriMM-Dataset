module comparator_2bit (
    input [1:0] A,
    input [1:0] B,
    output reg Equal,
    output reg A_gt_B,
    output reg A_lt_B
);

always @(*) begin
    Equal = (A == B);
    A_gt_B = (A > B);
    A_lt_B = (A < B);
end

endmodule