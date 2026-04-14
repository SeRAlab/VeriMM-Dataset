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
    reg [16:0] A; // Augmented dividend
    reg [15:0] B; // Divisor
    reg [4:0] count;
    reg state; // state = 0: idle, state = 1: dividing

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            A <= 0;
            B <= 0;
            quotient <= 0;
            remainder <= 0;
            count <= 0;
            done <= 0;
            state <= 0;
        end else begin
            case (state)
                0: begin // Idle state
                    if (start) begin
                        A <= {1'b0, dividend}; // Initialize A with the dividend
                        B <= divisor;          // Initialize B with the divisor
                        quotient <= 0;         // Reset quotient
                        remainder <= 0;        // Reset remainder
                        count <= 16;           // Set count to 16
                        done <= 0;             // Not done
                        state <= 1;            // Go to dividing state
                    end
                end
                1: begin // Dividing state
                    if (count > 0) begin
                        A <= A << 1;              // Shift A left
                        A[0] <= 0;                 // Set the least significant bit to 0
                        if (A >= {1'b0, B}) begin // If A >= B
                            A <= A - {1'b0, B};      // Subtract B from A
                            quotient <= (quotient << 1) | 1'b1; // Shift quotient and set LSB to 1
                        end else begin
                            quotient <= quotient << 1; // Shift quotient and set LSB to 0
                        end
                        count <= count - 1;        // Decrement count
                    end else begin
                        remainder <= A[15:0];      // Set remainder
                        done <= 1;                 // Mark as done
                        state <= 0;                // Go back to idle state
                    end
                end
            endcase
        end
    end
endmodule