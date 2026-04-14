module restoring_divider (
    input clk,
    input rst,
    input [3:0] dividend,
    input [3:0] divisor,
    output reg [3:0] quotient,
    output reg [3:0] remainder,
    output reg done
);
    reg [3:0] A, Q, M;
    reg [2:0] count;
    reg [1:0] state;

    localparam IDLE = 2'b00, DIVIDE = 2'b01, DONE = 2'b10;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            A <= 4'b0000;
            Q <= dividend;
            M <= divisor;
            quotient <= 4'b0000;
            remainder <= 4'b0000;
            count <= 3'd4;
            done <= 0;
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    if (divisor != 0) begin
                        A <= dividend;
                        Q <= 4'b0000;
                        count <= 3'd4;
                        state <= DIVIDE;
                        done <= 0;
                    end else begin
                        done <= 1; // Division by zero case
                    end
                end
                DIVIDE: begin
                    if (count > 0) begin
                        A <= {A[2:0], Q[3]};
                        Q <= {Q[2:0], 1'b0}; // Shift left
                        A <= A - M; // Subtract divisor
                        if (A[3] == 1) begin
                            A <= A + M; // Restore if negative
                            Q[0] <= 1'b0; // Set quotient bit to 0
                        end else begin
                            Q[0] <= 1'b1; // Set quotient bit to 1
                        end
                        count <= count - 1;
                    end else begin
                        quotient <= Q;
                        remainder <= A;
                        state <= DONE;
                    end
                end
                DONE: begin
                    done <= 1;
                end
            endcase
        end
    end
endmodule