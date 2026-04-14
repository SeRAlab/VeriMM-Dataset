module booth_multiplier(
    input signed [3:0] multiplicand,
    input signed [3:0] multiplier,
    output reg signed [7:0] product
);
    reg [3:0] A, Q, M;
    reg Q_1;
    integer i;

    always @(*) begin
        A = 0;
        Q = multiplier;
        M = multiplicand;
        Q_1 = 0;
        product = 0;

        for (i = 0; i < 4; i = i + 1) begin
            if (Q[0] == 1 && Q_1 == 0) begin
                A = A + M;  // A = A + M
            end else if (Q[0] == 0 && Q_1 == 1) begin
                A = A - M;  // A = A - M
            end
            
            // Arithmetic right shift
            Q_1 = Q[0];
            Q = {A[0], Q[3:1]};  // Shift Q right
            A = {A[3], A[3:1]} >> 1;  // Shift A right
        end
        
        product = {A, Q};  // Combine A and Q for the final product
    end
endmodule