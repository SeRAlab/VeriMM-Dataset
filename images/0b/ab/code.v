module comparator_2bit (
    input [1:0] A,
    input [1:0] B,
    output reg Equal,
    output reg A_greater,
    output reg B_greater
);

always @(*) begin
    Equal = (A == B);
    A_greater = (A > B);
    B_greater = (A < B);
end

endmodule