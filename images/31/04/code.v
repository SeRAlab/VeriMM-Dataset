module comparator_16bit (
    input [15:0] A,
    input [15:0] B,
    output reg A_gt_B,
    output reg A_lt_B,
    output reg A_eq_B
);

always @(*) begin
    if (A > B) begin
        A_gt_B = 1;
        A_lt_B = 0;
        A_eq_B = 0;
    end else if (A < B) begin
        A_gt_B = 0;
        A_lt_B = 1;
        A_eq_B = 0;
    end else begin
        A_gt_B = 0;
        A_lt_B = 0;
        A_eq_B = 1;
    end
end

endmodule