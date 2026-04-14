module comparator_64bit (
    input [63:0] A,
    input [63:0] B,
    output reg A_gt_B,
    output reg A_eq_B,
    output reg A_lt_B
);
    
    always @(*) begin
        A_gt_B = (A > B);
        A_eq_B = (A == B);
        A_lt_B = (A < B);
    end

endmodule