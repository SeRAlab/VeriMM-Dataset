module non_restoring_divider(
    input [7:0] dividend,
    input [7:0] divisor,
    output reg [7:0] quotient,
    output reg [7:0] remainder,
    input clk,
    input start,
    output reg done
);
    reg [7:0] A; // Accumulator
    reg [7:0] Q; // Quotient
    reg [7:0] M; // Divisor
    reg [3:0] count;

    always @(posedge clk) begin
        if (start) begin
            A <= 8'b0;
            Q <= dividend;
            M <= divisor;
            count <= 8; // Number of bits
            done <= 0;
        end else if (count > 0) begin
            A <= {A[6:0], Q[7]};
            Q <= {Q[6:0], 1'b0};
            A = A - M;

            if (A[7] == 1) begin // If A is negative
                A <= A + M;
                Q[0] <= 0; // Set LSB to 0
            end else begin
                Q[0] <= 1; // Set LSB to 1
            end

            count <= count - 1;
        end else if (count == 0) begin
            remainder <= A;
            quotient <= Q;
            done <= 1;
        end
    end
endmodule