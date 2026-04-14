module booth_multiplier(
    input signed [3:0] A,
    input signed [3:0] B,
    output reg signed [7:0] P
);
    reg signed [7:0] M, Q;
    reg Q1;
    integer i;

    always @(*) begin
        M = A; // Multiplicand
        Q = B; // Multiplier
        Q1 = 0; // Q-1
        P = 0; // Clear product

        for (i = 0; i < 4; i = i + 1) begin
            case ({Q[0], Q1})
                2'b01: P = P + M;     // Add M
                2'b10: P = P - M;     // Subtract M
            endcase
            // Arithmetic right shift P and Q
            {P, Q} = {P[7], P, Q[7:1]};
            Q1 = Q[0]; // Update Q-1
        end
    end
endmodule