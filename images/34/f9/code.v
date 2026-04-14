module non_restoring_divider(
    input [7:0] dividend,
    input [7:0] divisor,
    output reg [7:0] quotient,
    output reg [7:0] remainder,
    input start,
    input clk,
    input rst
);
    reg [7:0] A; // Register for the accumulator
    reg [7:0] Q; // Register for the quotient
    reg [3:0] count; // Counter for the number of bits
    reg done;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            A <= 0;
            Q <= 0;
            quotient <= 0;
            remainder <= 0;
            count <= 8;
            done <= 0;
        end else if (start && !done) begin
            A <= dividend; // Load dividend to A
            Q <= 0; // Clear quotient
            count <= 8; // Start with 8 bits
            done <= 0;
        end else if (count > 0) begin
            A <= {A[6:0], Q[7]}; // Shift A left
            Q <= {Q[6:0], 1'b0}; // Shift Q left and append 0
            A = A - divisor; // Subtract divisor from A

            if (A[7] == 0) begin // If A is non-negative
                Q[0] = 1; // Set Q's LSB to 1
            end else begin
                Q[0] = 0; // Set Q's LSB to 0
                A = A + divisor; // Restore A
            end
            count = count - 1; // Decrement count
        end else if (count == 0) begin
            quotient <= Q; // Output the quotient
            remainder <= A; // Output the remainder
            done <= 1; // Indicate done
        end
    end
endmodule