module non_restoring_divider (
    input wire clk,
    input wire start,
    input wire [3:0] dividend,
    input wire [3:0] divisor,
    output reg [3:0] quotient,
    output reg [3:0] remainder,
    output reg done
);
    reg [3:0] A; // Accumulator
    reg [3:0] Q; // Quotient
    reg [3:0] M; // Divisor
    reg [2:0] count; // Count for the number of bits processed
    reg state; // State variable

    always @(posedge clk) begin
        if (start) begin
            A <= dividend; // Load dividend into A
            Q <= 4'b0000; // Initialize quotient to 0
            M <= divisor; // Load divisor
            count <= 4; // Set bit count to 4
            done <= 0; // Reset done signal
            state <= 1; // Start state
        end else if (state) begin
            if (count > 0) begin
                // Shift left A and Q
                A <= {A[2:0], Q[3]}; // Shift A left
                Q <= {Q[2:0], 1'b0}; // Shift Q left
                A <= A - M; // Subtract M from A

                if (A[3] == 1) begin // If A is negative
                    A <= A + M; // Restore A
                    Q[0] <= 0; // Set least significant bit of Q to 0
                end else begin
                    Q[0] <= 1; // Set least significant bit of Q to 1
                end

                count <= count - 1; // Decrement count
            end else begin
                remainder <= A; // Final A is the remainder
                quotient <= Q; // Final Q is the quotient
                done <= 1; // Set done signal
                state <= 0; // End state
            end
        end
    end
endmodule