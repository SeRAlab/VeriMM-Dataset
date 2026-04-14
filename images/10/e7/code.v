module booth_multiplier(
    input signed [3:0] A,
    input signed [3:0] B,
    output reg signed [7:0] P
);
    reg [7:0] M;
    reg [7:0] Q;
    reg Q_1;
    integer i;

    always @(*) begin
        M = {A, 4'b0000}; // Extend A to 8 bits
        Q = {B, 4'b0}; // Extend B to 8 bits
        Q_1 = 0; // Initialize Q-1

        P = 0; // Initialize product

        for (i = 0; i < 4; i = i + 1) begin
            case ({Q[0], Q_1})
                2'b01: P = P + M; // P = P + M
                2'b10: P = P - M; // P = P - M
            endcase
            // Arithmetic Right Shift
            {P, Q} = {P[7], P[6:0], Q[7], Q[6:0]} >> 1;
            Q_1 = Q[0];
        end
    end
endmodule