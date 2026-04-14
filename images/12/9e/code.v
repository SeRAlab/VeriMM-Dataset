module booth_multiplier (
    input signed [3:0] A,
    input signed [3:0] B,
    output reg signed [7:0] P
);
    reg signed [7:0] M;
    reg signed [7:0] Q;
    reg Q_1; // Previous least significant bit of Q
    integer i;

    always @(*) begin
        M = {4'b0000, A}; // Extend A to 8 bits
        Q = {4'b0000, B}; // Extend B to 8 bits
        Q_1 = 0;          // Initialize Q_1 to 0
        P = 0;           // Initialize product to 0

        for (i = 0; i < 4; i = i + 1) begin
            case ({Q[0], Q_1})
                2'b01: P = P + M;      // Add M to P
                2'b10: P = P - M;      // Subtract M from P
            endcase
            
            // Arithmetic right shift
            {P, Q} = {P[7], P, Q[7:1]};
            Q_1 = Q[0]; // Update Q_1 to current Q[0]
        end
    end
endmodule