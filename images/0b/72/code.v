module magnitude_comparator (
    input [3:0] A,
    input [3:0] B,
    output reg A_greater,
    output reg A_less,
    output reg A_equal
);
    always @(*) begin
        A_greater = (A > B);
        A_less = (A < B);
        A_equal = (A == B);
    end
endmodule