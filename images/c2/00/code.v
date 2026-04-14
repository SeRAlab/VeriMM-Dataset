module ripple_adder (
    input [3:0] A,
    input [3:0] B,
    input CIN,
    output reg [3:0] SUM,
    output reg COUT
);

    always @(*) begin
        SUM = A + B + CIN;
        COUT = (A[3] & B[3]) | (A[3] & CIN) | (B[3] & CIN);
    end

endmodule