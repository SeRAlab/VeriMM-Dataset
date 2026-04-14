module comparator_16bit (
    input [15:0] A,
    input [15:0] B,
    output reg A_equals_B,
    output reg A_greater_B,
    output reg A_less_B
);
    always @(*) begin
        A_equals_B = (A == B);
        A_greater_B = (A > B);
        A_less_B = (A < B);
    end
endmodule