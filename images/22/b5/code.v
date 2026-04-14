module non_restoring_divider(
    input clk,
    input start,
    input [7:0] dividend,
    input [3:0] divisor,
    output reg [7:0] quotient,
    output reg [3:0] remainder,
    output reg done
);
    reg [7:0] A; // Accumulator
    reg [3:0] Q; // Quotient
    reg [3:0] M; // Divisor
    reg [3:0] count;
    reg state; // 0 for idle, 1 for dividing

    always @(posedge clk) begin
        if (start) begin
            A <= dividend; // Load dividend
            M <= divisor;  // Load divisor
            Q <= 0;        // Clear quotient
            count <= 8;    // Set count to width of dividend
            state <= 1;    // Start dividing
            done <= 0;     // Reset done signal
        end else if (state) begin
            if (count > 0) begin
                {A, Q} <= {A[7:0], Q[3:0]} - {4'b0, M}; // Subtract M
                if (A[7]) begin
                    A <= {A[7:0], Q[3:0]} + {4'b0, M}; // Restore A
                    Q <= {Q[3:0], 1'b0}; // Shift left and append 0
                end else begin
                    Q <= {Q[3:0], 1'b1}; // Shift left and append 1
                end
                count <= count - 1; // Decrement count
            end else begin
                quotient <= Q; // Output quotient
                remainder <= A[3:0]; // Output remainder
                done <= 1; // Indicate operation done
                state <= 0; // Go to idle
            end
        end
    end
endmodule