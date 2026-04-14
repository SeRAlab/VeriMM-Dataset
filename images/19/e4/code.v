module non_restoring_divider (
    input clk,
    input rst,
    input start,
    input [15:0] dividend,
    input [15:0] divisor,
    output reg [15:0] quotient,
    output reg [15:0] remainder,
    output reg done
);
    reg [15:0] A; // Accumulator
    reg [15:0] Q; // Quotient register
    reg [15:0] M; // Divisor
    reg [4:0] count; // Counter for the number of bits
    reg state; // State for FSM

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            A <= 0;
            Q <= 0;
            M <= 0;
            count <= 0;
            done <= 0;
            quotient <= 0;
            remainder <= 0;
            state <= 0;
        end else if (start && state == 0) begin
            A <= dividend;
            M <= divisor;
            Q <= 0;
            count <= 16; // Start with 16 bits
            done <= 0;
            state <= 1;
        end else if (state == 1) begin
            if (count > 0) begin
                {A, Q} <= {A[14:0], Q[14:0], 1'b0}; // Shift left
                A <= A - M; // Subtract M
                
                if (A[15] == 1) begin // If A is negative
                    A <= A + M; // Add M back
                    Q[0] <= 0; // Set Q bit to 0
                end else begin
                    Q[0] <= 1; // Set Q bit to 1
                end
                count <= count - 1; // Decrement count
            end else begin
                remainder <= A;
                quotient <= Q;
                done <= 1; // Operation complete
                state <= 0; // Go back to idle
            end
        end
    end
endmodule