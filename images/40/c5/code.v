module booth_multiplier(
    input signed [3:0] A, // Multiplicand
    input signed [3:0] B, // Multiplier
    output reg signed [7:0] P // Product
);
    reg [3:0] M; // Multiplicand
    reg [3:0] Q; // Multiplier
    reg Qn; // Q-1
    reg [7:0] A_temp; // A shifted for addition
    integer i;

    always @(*) begin
        // Initialize registers
        M = A;
        Q = B;
        Qn = 0;
        P = 0;

        for (i = 0; i < 4; i = i + 1) begin
            case ({Q[0], Qn})
                2'b01: P = P + M; // Add M to P
                2'b10: P = P - M; // Subtract M from P
                default: ;
            endcase

            // Arithmetic right shift
            {P[7], P} = P >> 1;
            P[0] = Q[3];
            Qn = Q[0];
            Q = {P[0], Q[3:1]}; // Shift Q
        end
    end
endmodule