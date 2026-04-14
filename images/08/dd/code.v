module booth_multiplier (
    input signed [3:0] A,
    input signed [3:0] B,
    output reg signed [7:0] P
);
    reg [3:0] Q;
    reg [3:0] Q1;
    reg [7:0] M;
    integer i;

    always @(*) begin
        P = 0;
        Q = B;
        Q1 = 0;
        M = A;

        for (i = 0; i < 4; i = i + 1) begin
            case ({Q[0], Q1})
                2'b01: P = P + M; // Add M
                2'b10: P = P - M; // Subtract M
                default: ;
            endcase

            // Arithmetic right shift
            Q1 = Q[0];
            Q = {P[0], Q[3:1]};
            P = P >>> 1;
        end
    end
endmodule