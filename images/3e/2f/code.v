module booth_multiplier (
    input signed [3:0] multiplicand,
    input signed [3:0] multiplier,
    output reg signed [7:0] product
);
    reg [7:0] A, Q, M;
    reg Q_1;
    integer i;

    always @(*) begin
        A = 0;
        Q = {4'b0, multiplier};
        M = {4'b0, multiplicand};
        Q_1 = 0;
        product = 0;

        for (i = 0; i < 4; i = i + 1) begin
            if (Q[0] == 1 && Q_1 == 0) begin
                A = A + M; // Add multiplicand
            end else if (Q[0] == 0 && Q_1 == 1) begin
                A = A - M; // Subtract multiplicand
            end
            
            // Arithmetic right shift
            Q_1 = Q[0];
            {A, Q} = {A, Q} >> 1;
            A[7] = A[6]; // Preserve sign bit
        end
        
        product = {A[7], A[6:0], Q[3:0]};
    end
endmodule