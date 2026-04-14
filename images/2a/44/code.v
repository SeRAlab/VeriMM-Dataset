module non_restoring_divider (
    input clk,
    input reset,
    input start,
    input [7:0] A, // Dividend
    input [7:0] B, // Divisor
    output reg [7:0] Q, // Quotient
    output reg [7:0] R, // Remainder
    output reg done // Done signal
);
    reg [7:0] dividend;
    reg [7:0] divisor;
    reg [3:0] count;
    reg state; // 0: idle, 1: dividing

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            Q <= 8'b0;
            R <= 8'b0;
            done <= 1'b0;
            state <= 1'b0;
            count <= 4'b0;
        end else begin
            case (state)
                0: begin // Idle state
                    if (start) begin
                        dividend <= A;
                        divisor <= B;
                        Q <= 8'b0;
                        R <= A;
                        count <= 4'b0;
                        state <= 1'b1; // Go to dividing state
                    end
                end
                1: begin // Dividing state
                    if (count < 8) begin
                        R <= {R[6:0], 1'b0}; // Shift left
                        Q <= {Q[6:0], 1'b0}; // Shift left quotient
                        R <= R - divisor; // Subtract divisor
                        if (R[7] == 1'b0) begin // If R >= 0
                            Q[0] <= 1'b1; // Set the least significant bit of Q to 1
                        end else begin
                            R <= R + divisor; // Restore R
                        end
                        count <= count + 1;
                    end else begin
                        done <= 1'b1; // Division done
                        state <= 1'b0; // Go back to idle state
                    end
                end
            endcase
        end
    end
endmodule