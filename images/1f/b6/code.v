module BoothMultiplier (
    input signed [3:0] A,
    input signed [3:0] B,
    output reg signed [7:0] P
);
    reg signed [3:0] M;
    reg signed [3:0] Q;
    reg Qn;
    reg signed [7:0] A_ext;
    reg signed [7:0] Q_ext;
    integer i;

    always @(*) begin
        M = A;
        Q = B;
        Qn = 0; // Initialize Q-1 to 0
        A_ext = {4'b0000, M}; // Extend A to 8 bits
        Q_ext = {4'b0000, Q}; // Extend Q to 8 bits
        P = 0; // Initialize product

        // Booth's algorithm
        for (i = 0; i < 4; i = i + 1) begin
            if (Q[0] == 1 && Qn == 0) begin
                P = P + A_ext; // P = P + M
            end else if (Q[0] == 0 && Qn == 1) begin
                P = P - A_ext; // P = P - M
            end
            // Arithmetic right shift
            {Q_ext, P} = {P[7], Q_ext, P} >> 1;
            Qn = Q_ext[0]; // Update Q-1
        end
    end
endmodule