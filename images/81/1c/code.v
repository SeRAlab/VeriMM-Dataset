module top_module(
    input A,
    input B,
    input CIN,
    output reg SUM,
    output reg COUT
);always @(*) begin
        SUM = A ^ B ^ CIN;
        COUT = (A & B) | (CIN & A) | (CIN & B);
    end

endmodule