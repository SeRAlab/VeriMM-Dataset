module non_restoring_divider(
    input clk,
    input rst,
    input [3:0] numerator,
    input [3:0] denominator,
    output reg [3:0] quotient,
    output reg [3:0] remainder,
    output reg done
);
    reg [3:0] A; // Accumulator
    reg [3:0] Q; // Quotient
    reg [3:0] M; // Divisor
    reg [2:0] count; // Bit counter
    reg state; // State for the division process

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            A <= 4'b0000;
            Q <= 4'b0000;
            M <= denominator;
            count <= 3'b100; // 4 bits
            done <= 0;
            quotient <= 4'b0000;
            remainder <= 4'b0000;
            state <= 0;
        end else if (state == 0) begin
            if (count > 0) begin
                A <= {A[2:0], Q[3]}; // Shift left A
                A <= A - M; // A = A - M
                if (A[3] == 1) begin // If A < 0
                    A <= A + M; // Restore A
                    Q <= {Q[2:0], 1'b0}; // Set quotient bit to 0
                end else begin
                    Q <= {Q[2:0], 1'b1}; // Set quotient bit to 1
                end
                count <= count - 1; // Decrement count
            end else begin
                quotient <= Q; // Set final quotient
                remainder <= A; // Set final remainder
                done <= 1; // Indicate division is done
                state <= 1; // Move to done state
            end
        end
    end
endmodule