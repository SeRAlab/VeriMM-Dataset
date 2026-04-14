module booth_multiplier (
    input signed [n-1:0] A,
    input signed [n-1:0] B,
    output reg signed [2*n-1:0] P
);
    parameter n = 4; // You can change this parameter for different bit widths
    reg signed [2*n-1:0] M;
    reg signed [n-1:0] Q;
    reg Qn;
    reg signed [2*n-1:0] A_temp;
    integer i;

    always @(*) begin
        M = A; // Multiplicand
        Q = B; // Multiplier
        Qn = 0; // Qn starts as 0
        P = 0; // Clear product

        for (i = 0; i < n; i = i + 1) begin
            if (Q[0] == 1 && Qn == 0) begin
                P = P + M; // Add M to the product
            end else if (Q[0] == 0 && Qn == 1) begin
                P = P - M; // Subtract M from the product
            end

            Qn = Q[0]; // Store Qn
            P = P >> 1; // Arithmetic right shift P
            Q = {P[2*n-1], Q}; // Extend Q with the sign bit of P
        end
    end
endmodule