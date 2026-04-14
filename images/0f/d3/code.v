module booth_multiplier (
    input signed [3:0] A,
    input signed [3:0] B,
    output reg signed [7:0] P
);
    reg [3:0] Q;
    reg [3:0] M;
    reg [3:0] Q_1;
    reg [3:0] count;
    
    always @(*) begin
        M = A;  // Multiplicand
        Q = B;  // Multiplier
        Q_1 = 0; // Initialize Q-1
        P = 0;   // Initialize product
        
        for (count = 0; count < 4; count = count + 1) begin
            case ({Q[0], Q_1})
                2'b01: P = P + {M, 4'b0000}; // Add M to P
                2'b10: P = P - {M, 4'b0000}; // Subtract M from P
            endcase
            {P, Q} = {P[7:0], Q[3:1], Q[0]}; // Arithmetic right shift
            Q_1 = Q[0]; // Update Q-1
        end
    end
endmodule