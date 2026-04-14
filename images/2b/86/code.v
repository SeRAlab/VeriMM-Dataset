module restoring_divider (
    input clk,
    input rst,
    input start,
    input [7:0] dividend,   // 8-bit dividend
    input [3:0] divisor,    // 4-bit divisor
    output reg [3:0] quotient, // 4-bit quotient
    output reg [3:0] remainder, // 4-bit remainder
    output reg done
);
    reg [7:0] A; // Accumulator (8 bits)
    reg [3:0] Q; // Quotient (4 bits)
    reg [3:0] M; // Divisor (4 bits)
    reg [3:0] count; // Counter
    reg state; // State indication

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            A <= 0;
            Q <= 0;
            M <= 0;
            quotient <= 0;
            remainder <= 0;
            done <= 0;
            count <= 0;
            state <= 0;
        end
        else if (start) begin
            if (state == 0) begin
                A <= dividend; // Load dividend into A
                M <= divisor;  // Load divisor into M
                Q <= 0;        // Initialize quotient
                count <= 4;    // Set count for 4 bits
                state <= 1;    // Move to next state
                done <= 0;
            end
            else if (state == 1) begin
                // Subtract M from A
                A <= A - {4'b0, M};
                Q <= {Q[2:0], 1'b1}; // Shift in 1 for quotient
                if (A[7]) begin // If A is negative
                    A <= A + {4'b0, M}; // Restore A
                    Q <= {Q[2:0], 1'b0}; // Shift in 0 for quotient
                end

                count <= count - 1;
                if (count == 0) begin
                    quotient <= Q;
                    remainder <= A[3:0]; // Lower 4 bits are remainder
                    done <= 1; // Division done
                    state <= 0; // Reset to initial state
                end
            end
        end
    end
endmodule