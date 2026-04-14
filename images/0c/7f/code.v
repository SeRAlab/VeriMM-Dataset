module SVM (
    input [3:0] X1,
    input [3:0] X2,
    input B,
    output reg decision
);
    parameter W1 = 4'b0010; // Weight for X1
    parameter W2 = 4'b1111; // Weight for X2 (-1 in 4-bit two's complement)

    always @(*) begin
        if ((X1 * W1 + X2 * W2 + B) > 0)
            decision = 1'b1;
        else
            decision = 1'b0;
    end
endmodule