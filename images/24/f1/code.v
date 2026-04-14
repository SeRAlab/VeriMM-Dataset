module non_restoring_divider (
    input clk,
    input reset,
    input [7:0] dividend,
    input [7:0] divisor,
    input start,
    output reg [15:0] quotient,
    output reg [7:0] remainder,
    output reg done
);

    reg [15:0] A; // Accumulator
    reg [7:0] B; // Divisor
    reg [4:0] count;
    reg state; // 0: idle, 1: busy

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            A <= 0;
            B <= 0;
            count <= 0;
            quotient <= 0;
            remainder <= 0;
            done <= 0;
            state <= 0;
        end else if (start && state == 0) begin
            // Initialize A and B
            A <= {8'b0, dividend}; // Load dividend
            B <= divisor;          // Load divisor
            quotient <= 0;        // Clear quotient
            remainder <= 0;       // Clear remainder
            count <= 8;          // Set count for 8 bits
            state <= 1;          // Set state to busy
            done <= 0;
        end else if (state == 1) begin
            if (count > 0) begin
                A <= {A[14:0], 1'b0}; // Shift A left
                if (A[15:8] >= B) begin
                    A <= A - {B, 8'b0}; // Subtract B
                    quotient <= {quotient[14:0], 1'b1}; // Append 1 to quotient
                end else begin
                    quotient <= {quotient[14:0], 1'b0}; // Append 0 to quotient
                end
                count <= count - 1; // Decrement count
            end else begin
                remainder <= A[7:0]; // Remainder is the last 8 bits of A
                state <= 0;          // Set state back to idle
                done <= 1;           // Indicate done
            end
        end
    end
endmodule