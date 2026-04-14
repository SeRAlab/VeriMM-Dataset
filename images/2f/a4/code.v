module restoring_divider(
    input clk,
    input rst,
    input start,
    input [3:0] dividend,
    input [3:0] divisor,
    output reg [3:0] quotient,
    output reg [3:0] remainder,
    output reg done
);
    reg [3:0] A; // Accumulator
    reg [3:0] Q; // Quotient
    reg [4:0] D; // Divisor with one bit extension for subtraction
    reg [2:0] count; // Count for cycle
    reg state; // State machine

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            A <= 0;
            Q <= 0;
            remainder <= 0;
            quotient <= 0;
            done <= 0;
            count <= 0;
            state <= 0;
        end else begin
            case (state)
                0: begin // Initialization
                    if (start) begin
                        A <= dividend;
                        Q <= 0;
                        D <= {1'b0, divisor}; // Extend divisor
                        count <= 4; // Set count for 4 cycles
                        state <= 1; // Move to next state
                        done <= 0;
                    end
                end
                1: begin // Division process
                    if (count > 0) begin
                        A <= {A[2:0], Q[3]}; // Shift left
                        if (A >= D[3:0]) begin
                            A <= A - D[3:0]; // Subtract divisor
                            Q <= {Q[2:0], 1'b1}; // Set bit in quotient
                        end else begin
                            Q <= {Q[2:0], 1'b0}; // Clear bit in quotient
                        end
                        count <= count - 1;
                    end else begin
                        remainder <= A;
                        quotient <= Q;
                        done <= 1; // Indicate done
                        state <= 0; // Reset state
                    end
                end
            endcase
        end
    end
endmodule