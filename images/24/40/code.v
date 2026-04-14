module booth_multiplier (
    input [3:0] A, // Multiplicand
    input [3:0] B, // Multiplier
    output reg [7:0] P // Product
);
    reg [7:0] A_ext, B_ext;
    reg [3:0] Q;
    reg Q_1;
    integer i;

    always @(*) begin
        // Initialize variables
        A_ext = {4'b0000, A}; // Extend A to 8 bits
        B_ext = {4'b0000, B}; // Extend B to 8 bits
        Q = B;                // Load multiplier
        P = 8'b00000000;     // Initialize product to 0
        Q_1 = 1'b0;          // Initialize Q-1

        for(i = 0; i < 4; i = i + 1) begin
            case({Q[0], Q_1})
                2'b01: P = P + A_ext;          // Add A
                2'b10: P = P - A_ext;          // Subtract A
            endcase
            // Arithmetic right shift
            {P, Q} = {P[7], P[7:1], Q[3]}; // Shift operation
            Q_1 = Q[0];                    // Update Q-1
        end
    end
endmodule