module restoring_divider (
    input clk,
    input reset,
    input start,
    input [9:0] dividend,
    input [9:0] divisor,
    output reg [9:0] quotient,
    output reg [9:0] remainder,
    output reg done
);
    reg [9:0] A; // Accumulator
    reg [9:0] Q; // Quotient register
    reg [9:0] M; // Divisor
    reg [4:0] count; // Count for the number of bits processed
    reg state; // State variable for the FSM

    // State definitions
    localparam IDLE = 1'b0, DIVIDE = 1'b1;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            A <= 10'b0;
            Q <= 10'b0;
            M <= 10'b0;
            quotient <= 10'b0;
            remainder <= 10'b0;
            count <= 5'b0;
            done <= 1'b0;
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    if (start) begin
                        A <= dividend;
                        M <= divisor;
                        Q <= 10'b0;
                        count <= 10;
                        done <= 1'b0;
                        state <= DIVIDE;
                    end
                end
                DIVIDE: begin
                    if (count > 0) begin
                        A <= {A[8:0], Q[9]}; // Shift A left
                        Q[9] <= 1'b1; // Set the MSB of Q to 1
                        A = A - M; // Subtract M from A
                        if (A[9] == 1) begin // If A is negative
                            A <= A + M; // Restore A
                            Q[9] <= 1'b0; // Set MSB of Q to 0
                        end
                        count <= count - 1;
                    end else begin
                        quotient <= Q;
                        remainder <= A;
                        done <= 1'b1;
                        state <= IDLE;
                    end
                end
            endcase
        end
    end
endmodule