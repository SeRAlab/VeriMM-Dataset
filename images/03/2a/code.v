module booth_multiplier (
    input signed [4:0] A,
    input signed [4:0] B,
    output reg signed [9:0] P
);
    reg [4:0] M;
    reg [4:0] Q;
    reg [9:0] Q_1;
    reg [9:0] A_temp;
    integer i;

    always @(*) begin
        M = A;
        Q = B;
        Q_1 = 0;
        P = 0;

        for (i = 0; i < 5; i = i + 1) begin
            if (Q[0] == 1 && Q_1 == 0) begin
                P = P + M; // Add M
            end else if (Q[0] == 0 && Q_1 == 1) begin
                P = P - M; // Subtract M
            end

            // Arithmetic right shift
            Q_1 = Q[0];
            {P[9], Q} = {P[9], Q} >> 1;
            P[0] = P[0]; // Maintain sign
            P[9] = P[9]; // Maintain sign
        end
    end
endmodule