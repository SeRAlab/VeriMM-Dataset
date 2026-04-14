module comparator_8bit (
    input [7:0] A,
    input [7:0] B,
    output reg A_greater,
    output reg A_equal,
    output reg A_less
);

always @(*) begin
    A_greater = (A > B);
    A_equal = (A == B);
    A_less = (A < B);
end

endmodule