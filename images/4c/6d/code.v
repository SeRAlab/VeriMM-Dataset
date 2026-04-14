module top_module(
    input [3:0] A,
    input [3:0] B,
    output reg EQ,
    output reg GT,
    output reg LT
);always @(*) begin
        EQ = (A == B);
        GT = (A > B);
        LT = (A < B);
    end

endmodule