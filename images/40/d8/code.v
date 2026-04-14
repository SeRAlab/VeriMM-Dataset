module restoring_divider (
    input clk,
    input reset,
    input start,
    input [7:0] dividend,
    input [7:0] divisor,
    output reg [7:0] quotient,
    output reg [7:0] remainder,
    output reg done
);
    reg [7:0] A; // Accumulator
    reg [3:0] count;
    reg [7:0] Q; // Quotient
    reg [7:0] M; // Divisor
    
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            quotient <= 8'b0;
            remainder <= 8'b0;
            done <= 0;
            A <= 8'b0;
            Q <= 8'b0;
            M <= 8'b0;
            count <= 4'b0;
        end else if (start) begin
            M <= divisor;
            A <= dividend;
            Q <= 8'b0;
            count <= 8; // Assuming 8-bit dividend
            done <= 0;
        end else if (count > 0) begin
            A = {A[6:0], Q[7]}; // Shift A left
            Q = {Q[6:0], 1'b0}; // Shift Q left
            A = A - M; // Subtract M from A
            if (A[7] == 1) begin // If A is negative
                A = A + M; // Restore A
                Q[0] = 1'b0; // Set the least significant bit of Q to 0
            end else begin
                Q[0] = 1'b1; // Set the least significant bit of Q to 1
            end
            count = count - 1; // Decrement count
        end else begin
            quotient <= Q; // Final quotient
            remainder <= A; // Final remainder
            done <= 1; // Indicate done
        end
    end
endmodule