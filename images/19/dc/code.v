module booth_multiplier (
    input signed [3:0] A,
    input signed [3:0] B,
    output reg signed [7:0] P
);
    reg [7:0] M; // Multiplicand
    reg [3:0] Q; // Multiplier
    reg Qn; // Q-1
    integer i;

    always @(*) begin
        M = {4'b0000, A}; // Extend A to 8 bits
        Q = B; // B is the multiplier
        P = 0; // Initial product
        Qn = 0; // Initialize Q-1

        for (i = 0; i < 4; i = i + 1) begin
            case ({Q[0], Qn})
                2'b01: P = P + M; // Add M to P
                2'b10: P = P - M; // Subtract M from P
                default: ; // Do nothing
            endcase
            
            // Arithmetic right shift
            {P, Q} = {P[7], P[6:0], Q[3:1], Q[0]};
            Qn = Q[0];
        end
    end
endmodule