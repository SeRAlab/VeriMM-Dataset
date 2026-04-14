module non_restoring_divider (
    input clk,
    input rst,
    input [7:0] dividend,
    input [7:0] divisor,
    input start,
    output reg [7:0] quotient,
    output reg remainder,
    output reg done
);
    reg [7:0] A; // Accumulator
    reg [7:0] Q; // Quotient
    reg [7:0] M; // Divisor
    reg [3:0] count; // Count for the number of bits processed
    reg state; // State variable to control the process

    parameter IDLE = 1'b0, DIVIDE = 1'b1;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            A <= 0;
            Q <= 0;
            M <= 0;
            count <= 0;
            quotient <= 0;
            remainder <= 0;
            done <= 0;
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    if (start) begin
                        A <= dividend; // Load dividend
                        M <= divisor; // Load divisor
                        Q <= 0;       // Clear quotient
                        count <= 8;   // Number of bits to process
                        done <= 0;    // Not done yet
                        state <= DIVIDE;
                    end
                end
                DIVIDE: begin
                    if (count > 0) begin
                        A <= {A[6:0], Q[7]}; // Shift A left
                        Q <= {Q[6:0], 1'b0};  // Shift Q left and append 0
                        
                        if (A >= M) begin
                            A <= A - M; // Subtract M from A
                            Q[0] <= 1;  // Set the least significant bit of Q
                        end
                        count <= count - 1; // Decrement count
                    end else begin
                        quotient <= Q; // Finalize quotient
                        remainder <= A; // Finalize remainder
                        done <= 1; // Mark as done
                        state <= IDLE; // Go back to IDLE
                    end
                end
            endcase
        end
    end
endmodule