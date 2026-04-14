module booth_multiplier #(parameter N = 4) (
    input wire [N-1:0] A,
    input wire [N-1:0] B,
    output reg [2*N-1:0] P
);
    reg [N-1:0] M, Q;
    reg Q_1;
    reg [N:0] A_ext, P_temp;
    integer i;

    always @(*) begin
        M = A;          // Multiplicand
        Q = B;          // Multiplier
        Q_1 = 1'b0;    // Previous Q bit
        A_ext = {1'b0, M}; // Extend A to N+1 bits
        P_temp = {N+1{1'b0}}; // Initialize product to 0
        P_temp[N:0] = {Q, Q_1}; // Combine Q and Q-1
        
        for (i = 0; i < N; i = i + 1) begin
            case ({Q[0], Q_1})
                2'b01: P_temp = P_temp + A_ext; // Add M
                2'b10: P_temp = P_temp - A_ext; // Subtract M
                default: P_temp = P_temp; // Do nothing
            endcase
            Q_1 = Q[0]; // Update previous Q bit
            Q = {P_temp[N], Q[N-1:1]}; // Shift right
            P_temp[N] = P_temp[N-1]; // Maintain sign bit
        end
        
        P = P_temp[N:1]; // Final product
    end
endmodule