module comparator_2bit (
    input [1:0] A,
    input [1:0] B,
    output reg Equal,
    output reg A_gt_B,
    output reg A_lt_B
);
    always @(*) begin
        if (A == B) begin
            Equal = 1'b1;
            A_gt_B = 1'b0;
            A_lt_B = 1'b0;
        end else if (A > B) begin
            Equal = 1'b0;
            A_gt_B = 1'b1;
            A_lt_B = 1'b0;
        end else begin
            Equal = 1'b0;
            A_gt_B = 1'b0;
            A_lt_B = 1'b1;
        end
    end
endmodule