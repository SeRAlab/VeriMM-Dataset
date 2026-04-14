module non_restoring_divider (
    input clk,
    input rst,
    input start,
    input [7:0] dividend,
    input [7:0] divisor,
    output reg [7:0] quotient,
    output reg [7:0] remainder,
    output reg done
);
    reg [7:0] A; // Accumulator
    reg [7:0] Q; // Quotient
    reg [4:0] count; // Counter for bit positions
    reg [7:0] M; // Divisor
    reg state; // State: 0 for idle, 1 for dividing

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            A <= 0;
            Q <= 0;
            count <= 0;
            done <= 0;
            state <= 0;
        end else if (start) begin
            M <= divisor;
            A <= dividend;
            Q <= 0;
            count <= 8; // Set count for 8 bits
            done <= 0;
            state <= 1;
        end else if (state) begin
            if (count > 0) begin
                // Left shift A and Q
                A <= {A[6:0], Q[7]};
                Q <= {Q[6:0], 1'b0};

                // Subtract M from A
                A = A - M;
                if (A[7] == 1) begin // If A is negative
                    A <= A + M; // Restore
                    Q[0] <= 0; // Set Q's LSB to 0
                end else begin
                    Q[0] <= 1; // Set Q's LSB to 1
                end

                count <= count - 1;
            end else begin
                // Division is done
                quotient <= Q;
                remainder <= A;
                done <= 1;
                state <= 0;
            end
        end
    end
endmodule