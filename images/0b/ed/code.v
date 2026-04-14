module BoothMultiplier (
    input wire [3:0] A, // Multiplicand
    input wire [3:0] B, // Multiplier
    output reg [7:0] P // Product
);
    reg [3:0] M; // Multiplicand
    reg [3:0] Q; // Multiplier
    reg Q_1; // Previous bit of Q
    reg [7:0] A_neg; // Two's complement of A
    integer i;

    always @(*) begin
        M = A;
        Q = B;
        Q_1 = 0; // Initial value of Q_1
        P = 0; // Initialize product to 0
        A_neg = ~M + 1; // Calculate the two's complement of M

        for (i = 0; i < 4; i = i + 1) begin
            case ({Q[0], Q_1})
                2'b01: P = P + M; // Add M to product
                2'b10: P = P + A_neg; // Subtract M (add -M) from product
            endcase
            // Arithmetic right shift
            {P[7], P} = {P[7], P} >> 1; // Shift product
            Q_1 = Q[0]; // Update Q_1
            Q = {P[0], Q[3:1]}; // Shift Q bits
        end
    end
endmodule