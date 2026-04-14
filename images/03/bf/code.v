module magnitude_comparator (
    input [4:0] A,
    input [4:0] B,
    output reg A_LT_B,
    output reg A_EQ_B,
    output reg A_GT_B
);
    always @(*) begin
        if (A < B) begin
            A_LT_B = 1;
            A_EQ_B = 0;
            A_GT_B = 0;
        end else if (A == B) begin
            A_LT_B = 0;
            A_EQ_B = 1;
            A_GT_B = 0;
        end else begin
            A_LT_B = 0;
            A_EQ_B = 0;
            A_GT_B = 1;
        end
    end
endmodule