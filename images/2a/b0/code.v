module Comparator16Bit(
    input [15:0] A,
    input [15:0] B,
    output reg equal,
    output reg greater,
    output reg less
);
    always @(*) begin
        equal = (A == B);
        greater = (A > B);
        less = (A < B);
    end
endmodule