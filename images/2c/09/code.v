module non_restoring_divider (
    input [7:0] dividend,
    input [7:0] divisor,
    input start,
    output reg [7:0] quotient,
    output reg [7:0] remainder,
    output reg valid
);
    integer i;
    reg [7:0] A, Q, M;
    reg Qn;

    always @(*) begin
        valid = 0;
        A = 0;
        Q = dividend;
        M = divisor;
        Qn = 0;

        if (start) begin
            for (i = 0; i < 8; i = i + 1) begin
                A = {A[6:0], Q[7]};
                Q = Q << 1;

                A = A - M;
                if (A[7] == 1) begin
                    A = A + M;
                    Q[0] = 0;
                end else begin
                    Q[0] = 1;
                end
            end
            quotient = Q;
            remainder = A;
            valid = 1;
        end
    end
endmodule