module SRT_Divider (
    input [15:0] dividend,
    input [15:0] divisor,
    output reg [15:0] quotient,
    output reg [15:0] remainder
);
    reg [15:0] A; // Accumulator
    reg [15:0] Q; // Quotient
    reg [15:0] M; // Divisor
    integer i;

    always @(*) begin
        A = 0;
        Q = 0;
        M = divisor;

        for (i = 15; i >= 0; i = i - 1) begin
            A = {A[14:0], dividend[i]}; // Shift left A by 1 and input next bit of dividend
            Q = {Q[14:0], 1'b0}; // Shift left Q by 1 and append 0

            if (A >= M) begin
                A = A - M; // Subtract divisor
                Q[0] = 1;   // Set last bit of Q
            end
        end

        quotient = Q;
        remainder = A;
    end
endmodule