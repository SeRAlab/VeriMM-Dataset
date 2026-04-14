module top_module(
    input [3:0] A,
    output reg [3:0] Q
);always @ (A) begin
        Q[0] = A[0] ^ 0;
        Q[1] = A[1] ^ A[0];
        Q[2] = A[2] ^ A[1];
        Q[3] = A[3] ^ A[2];
    end

endmodule