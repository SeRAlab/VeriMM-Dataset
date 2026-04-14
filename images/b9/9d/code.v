module top_module(
    input signed [3:0] A,
    input signed [3:0] B,
    output reg C
);always @(*) begin
        if (A[3] == 0 && B[3] == 1) // A is positive, B is negative
            C = 1;
        else if (A[3] == 1 && B[3] == 0) // A is negative, B is positive
            C = 0;
        else if (A[3] == 0 && B[3] == 0) // Both A and B are positive
            C = (A >= B) ? 1 : 0;
        else if (A[3] == 1 && B[3] == 1) // Both A and B are negative
            C = (A <= B) ? 1 : 0;
    end

endmodule