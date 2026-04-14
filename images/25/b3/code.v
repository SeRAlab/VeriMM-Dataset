module non_restoring_divider (
    input clk,
    input rst_n,
    input start,
    input [7:0] dividend,
    input [7:0] divisor,
    output reg [7:0] quotient,
    output reg [7:0] remainder,
    output reg done
);
    reg [7:0] A; // Dividend / Remainder
    reg [7:0] Q; // Quotient
    reg [3:0] count;
    reg state; // 0: idle, 1: dividing

    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            A <= 0;
            Q <= 0;
            count <= 0;
            done <= 0;
            quotient <= 0;
            remainder <= 0;
            state <= 0;
        end else begin
            case (state)
                0: begin // Idle state
                    if (start) begin
                        A <= dividend;
                        Q <= 0;
                        count <= 8; // 8 bits to process
                        done <= 0;
                        state <= 1; // Move to dividing state
                    end
                end
                1: begin // Dividing state
                    if (count > 0) begin
                        {A, Q} <= {A[7:1], Q[6:0], 1'b0}; // Shift left
                        if (A >= divisor) begin
                            A <= A - divisor; // Subtract divisor
                            Q[0] <= 1; // Set least significant bit of Q
                        end
                        count <= count - 1;
                    end else begin
                        quotient <= Q;
                        remainder <= A;
                        done <= 1;
                        state <= 0; // Back to idle
                    end
                end
            endcase
        end
    end
endmodule