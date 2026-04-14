module comparator_2bit(A, B, A_gt_B);
input [1:0] A, B;
output reg A_gt_B;

always @(*) begin
    if (A > B)
        A_gt_B = 1'b1;
    else
        A_gt_B = 1'b0;
end

endmodule