module booth_multiplier(
    input [3:0] A,
    input [3:0] B,
    output reg [7:0] P
);
    integer i;
    reg [3:0] A_temp;
    reg [4:0] M, Q;
    reg Q_1;
    
    always @(*) begin
        A_temp = A;
        M = A; // Multiplicand
        Q = B; // Multiplier
        Q_1 = 0; // Initialize Q-1
        P = 0; // Initialize product

        for (i = 0; i < 4; i = i + 1) begin
            if (Q[0] == 1 && Q_1 == 0) begin
                P = P + M; // Add M to P
            end else if (Q[0] == 0 && Q_1 == 1) begin
                P = P - M; // Subtract M from P
            end
            
            // Arithmetic right shift
            Q_1 = Q[0];
            Q = {P[0], Q[3:1]}; // Shift Q
            P = {P[7], P[7:1]}; // Shift P
        end
    end
endmodule