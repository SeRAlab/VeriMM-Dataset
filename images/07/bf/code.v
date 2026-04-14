module non_restoring_divider(
    input clk,
    input rst,
    input start,
    input [15:0] dividend,
    input [15:0] divisor,
    output reg [15:0] quotient,
    output reg [15:0] remainder,
    output reg done
);
    reg [15:0] A; // Register for the dividend
    reg [15:0] Q; // Register for the quotient
    reg [15:0] M; // Register for the divisor
    reg [4:0] count; // Bit counter
    reg state; // FSM state

    localparam IDLE = 1'b0;
    localparam DIVIDE = 1'b1;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            A <= 16'b0;
            Q <= 16'b0;
            M <= 16'b0;
            count <= 5'd16;
            done <= 1'b0;
            state <= IDLE;
        end
        else begin
            case (state)
                IDLE: begin
                    if (start) begin
                        A <= dividend;
                        M <= divisor;
                        Q <= 16'b0;
                        count <= 5'd16;
                        done <= 1'b0;
                        state <= DIVIDE;
                    end
                end
                DIVIDE: begin
                    if (count > 0) begin
                        {A, Q} <= {A[15:1], Q[14:0], 1'b0}; // Shift A and Q left
                        A <= A - M; // Subtract M from A
                        if (A[15] == 1'b1) begin
                            A <= A + M; // Restore A if negative
                            Q[0] <= 1'b0; // Set quotient bit to 0
                        end else begin
                            Q[0] <= 1'b1; // Set quotient bit to 1
                        end
                        count <= count - 1;
                    end else begin
                        remainder <= A;
                        quotient <= Q;
                        done <= 1'b1;
                        state <= IDLE; // Go back to idle
                    end
                end
            endcase
        end
    end
endmodule