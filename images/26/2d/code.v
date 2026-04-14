module booth_multiplier(
    input signed [3:0] A,
    input signed [3:0] B,
    output reg signed [7:0] product
);
    reg [3:0] M;
    reg [3:0] Q;
    reg Q_1;
    reg [4:0] A_neg;
    reg [7:0] P;
    integer i;

    always @(*) begin
        M = A;
        Q = B;
        Q_1 = 0; // Initialize Q-1
        A_neg = -M; // Calculate -M
        P = 0; // Initialize product

        for (i = 0; i < 4; i = i + 1) begin
            case ({Q[0], Q_1})
                2'b01: P = P + {M, 4'b0000}; // Add M
                2'b10: P = P + {A_neg, 4'b0000}; // Subtract M
            endcase

            // Arithmetic right shift
            {P[7], Q, Q_1} = {P[7], P[6:0], Q, Q_1} >> 1;
        end

        product = P; // Assign the final product
    end
endmodule