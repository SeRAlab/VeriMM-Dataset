module booth_multiplier (
    input signed [3:0] A,
    input signed [3:0] B,
    output reg signed [7:0] P
);
    reg [3:0] M; // Multiplicand
    reg [3:0] Q; // Multiplier
    reg [3:0] Q1; // Q[-1]
    reg [7:0] A_neg; // Negative of A
    integer i;

    always @(*) begin
        M = A;
        Q = B;
        Q1 = 0;
        P = 0;
        A_neg = ~M + 1; // Two's complement

        for (i = 0; i < 4; i = i + 1) begin
            case ({Q[0], Q1})
                2'b00: begin
                    // No operation
                end
                2'b01: begin
                    P = P + M; // P = P + M
                end
                2'b10: begin
                    P = P + A_neg; // P = P - M
                end
                2'b11: begin
                    // No operation
                end
            endcase
            
            // Right shift P and Q
            P = {P[7], P[7:1]};
            P[0] = Q[3];
            Q = {P[0], Q[3:1]};
            Q1 = Q[0];
        end
    end
endmodule