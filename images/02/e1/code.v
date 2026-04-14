module booth_multiplier (
    input [4:0] A,
    input [4:0] B,
    output reg [9:0] P
);
    reg [9:0] A_ext; // Extended A
    reg [9:0] B_ext; // Extended B
    reg [4:0] count;
    reg [9:0] Q;
    reg Q_1; // Previous Q bit
    reg [9:0] M; // Multiplier

    always @(*) begin
        A_ext = {5'b00000, A}; // Extend A
        B_ext = {5'b00000, B}; // Extend B
        Q = {5'b00000, B}; // Initialize Q
        Q_1 = 0; // Initialize Q-1
        M = A_ext; // M is A
        P = 10'b0; // Initialize Product

        for (count = 0; count < 5; count = count + 1) begin
            case ({Q[0], Q_1})
                2'b01: P = P + M; // Add M to P
                2'b10: P = P - M; // Subtract M from P
            endcase
            // Arithmetic right shift
            {P, Q} = {P[9], P, Q[9:1]};
            Q_1 = Q[0]; // Update Q-1
        end
    end
endmodule