module comparator_4bit (A, B, A_GT_B, A_EQ_B, A_LT_B);
input [3:0] A, B;
output reg A_GT_B, A_EQ_B, A_LT_B;

always @(*) begin
    if (A > B) begin
        A_GT_B = 1'b1;
        A_EQ_B = 1'b0;
        A_LT_B = 1'b0;
    end
    else if (A == B) begin
        A_GT_B = 1'b0;
        A_EQ_B = 1'b1;
        A_LT_B = 1'b0;
    end
    else begin
        A_GT_B = 1'b0;
        A_EQ_B = 1'b0;
        A_LT_B = 1'b1;
    end
end

endmodule