module restoring_divider (
    input clk,
    input rst,
    input start,
    input [4:0] dividend,
    input [2:0] divisor,
    output reg [4:0] quotient,
    output reg [2:0] remainder,
    output reg done
);
    reg [4:0] A; // Accumulator
    reg [4:0] Q; // Quotient
    reg [2:0] R; // Remainder
    reg [2:0] count; // Count for the number of bits processed
    reg state; // State variable (0 for idle, 1 for division)
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            A <= 0;
            Q <= 0;
            R <= 0;
            quotient <= 0;
            remainder <= 0;
            done <= 0;
            count <= 0;
            state <= 0;
        end else begin
            case (state)
                0: begin // Idle state
                    if (start) begin
                        A <= dividend; // Load dividend
                        Q <= 0; // Reset quotient
                        R <= divisor; // Load divisor
                        count <= 5; // Set count to number of bits
                        state <= 1; // Move to division state
                    end
                    done <= 0;
                end
                1: begin // Division state
                    if (count > 0) begin
                        // Left Shift
                        A <= {A[3:0], Q[4]}; // Concatenate for next bit
                        Q <= {Q[3:0], 1'b0}; // Shift quotient left
                        
                        // Subtract
                        if (A >= R) begin
                            A <= A - R; // Subtract divisor
                            Q[0] <= 1; // Set LSB of quotient
                        end
                        count <= count - 1; // Decrement count
                    end else begin
                        quotient <= Q; // Output quotient
                        remainder <= A; // Output remainder
                        done <= 1; // Indicate done
                        state <= 0; // Go back to idle
                    end
                end
            endcase
        end
    end
endmodule