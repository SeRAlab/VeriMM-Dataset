module comparator_8bit (
    input [7:0] A,
    input [7:0] B,
    output reg A_eq,
    output reg A_gt,
    output reg A_lt
);

always @(*) begin
    A_eq = (A == B);
    A_gt = (A > B);
    A_lt = (A < B);
end

endmodule