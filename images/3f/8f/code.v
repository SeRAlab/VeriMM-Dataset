module booth_multiplier (
    input signed [7:0] multiplicand,
    input signed [7:0] multiplier,
    output reg signed [15:0] product
);
    reg [7:0] M; // Multiplicand
    reg [7:0] Q; // Multiplier
    reg [15:0] A; // Accumulator
    reg Qn; // Previous Q0
    integer i;

    always @(*) begin
        M = multiplicand;
        Q = multiplier;
        A = 16'b0;
        Qn = 1'b0;
        product = 16'b0;

        for (i = 0; i < 8; i = i + 1) begin
            case ({Q[0], Qn})
                2'b01: A = A + {8'b0, M}; // A = A + M
                2'b10: A = A - {8'b0, M}; // A = A - M
            endcase

            // Arithmetic Right Shift
            {A, Q} = {A[15], A, Q} >> 1;
            Qn = Q[0];
        end

        product = {A, Q}; // Combine A and Q
    end
endmodule