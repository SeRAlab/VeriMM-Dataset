module booth_multiplier (
    input [3:0] A, // Multiplicand
    input [3:0] B, // Multiplier
    output reg [7:0] P // Product
);
    reg [3:0] M; // Copy of A
    reg [3:0] Q; // Copy of B
    reg [3:0] Q_1; // Previous bit of Q
    reg [7:0] A_shifted; // A shifted for addition/subtraction
    integer i;

    always @(*) begin
        // Initialize
        M = A;
        Q = B;
        Q_1 = 0;
        P = 0;

        // Booth's algorithm loop
        for (i = 0; i < 4; i = i + 1) begin
            case ({Q[0], Q_1})
                2'b01: P = P + {4'b0000, M}; // Add M to P
                2'b10: P = P - {4'b0000, M}; // Subtract M from P
                default: ; // Do nothing
            endcase

            // Shift right
            {P[7], P[6:0]} = P[7:0] >> 1; // Shift P right
            {Q_1, Q} = {Q[3], Q[2:0], Q_1}; // Shift Q and Q_1 right
        end
    end
endmodule