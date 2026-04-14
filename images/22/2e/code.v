module non_restoring_divider (
    input signed [7:0] dividend,
    input signed [7:0] divisor,
    output reg signed [7:0] quotient,
    output reg signed [7:0] remainder
);
    reg signed [7:0] A; // Accumulator
    reg signed [7:0] Q; // Quotient
    reg signed [7:0] M; // Divisor
    reg signed [7:0] Q1; // Q with a bit appended
    integer i;

    always @(*) begin
        A = 0;
        Q = dividend;
        M = divisor;
        quotient = 0;
        remainder = 0;

        for (i = 0; i < 8; i = i + 1) begin
            A = A << 1; // Shift A left
            A[0] = Q[7]; // Get the next bit of Q
            Q = Q << 1; // Shift Q left

            A = A - M; // Subtract M from A
            if (A[7] == 1) begin // If A is negative
                A = A + M; // Add M back to A
                Q[0] = 0; // Set the last bit of Q to 0
            end else begin
                Q[0] = 1; // Set the last bit of Q to 1
            end
        end

        quotient = Q;
        remainder = A;
    end
endmodule