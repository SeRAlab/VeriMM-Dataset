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
    reg [3:0] count; // Counter for iterations
    reg state; // State variable

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            A <= 0;
            Q <= 0;
            count <= 0;
            done <= 0;
            quotient <= 0;
            remainder <= 0;
            state <= 0;
        end else if (start) begin
            A <= dividend;
            Q <= 0;
            count <= 8; // Assuming 8-bit dividend/divisor
            done <= 0;
            state <= 1; // Start the division process
        end else if (state) begin
            if (count > 0) begin
                A = {A[6:0], Q[7]}; // Shift left
                if (A >= divisor) begin
                    A = A - divisor;
                    Q = Q | 1; // Set the least significant bit
                end else begin
                    Q = Q & ~1; // Clear the least significant bit
                end
                count = count - 1; // Decrement counter
            end else begin
                quotient <= Q;
                remainder <= A;
                done <= 1; // Indicate division is complete
                state <= 0; // Reset state
            end
        end
    end
endmodule