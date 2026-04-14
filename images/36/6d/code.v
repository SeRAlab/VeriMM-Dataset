module restoring_divider #(parameter N = 8) (
    input clk,
    input rst,
    input start,
    input [N-1:0] dividend,
    input [N-1:0] divisor,
    output reg [N-1:0] quotient,
    output reg [N-1:0] remainder,
    output reg done
);
    reg [N-1:0] A; // Accumulator
    reg [N-1:0] Q; // Quotient
    reg [N-1:0] M; // Divisor
    reg [N:0] count; // Counter for n bits
    reg state; // State register

    localparam IDLE = 1'b0, DIVIDING = 1'b1;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            A <= 0;
            Q <= 0;
            M <= 0;
            count <= 0;
            done <= 0;
            quotient <= 0;
            remainder <= 0;
            state <= IDLE;
        end else begin
            case (state)
                IDLE: begin
                    if (start) begin
                        A <= dividend;
                        M <= divisor;
                        Q <= 0;
                        count <= N;
                        state <= DIVIDING;
                    end
                end
                DIVIDING: begin
                    if (count > 0) begin
                        A <= {A[N-1], A[N-2:0]}; // Shift left A
                        A <= A - M; // Subtract M from A
                        if (A[N-1] == 1) begin // If A < 0
                            A <= A + M; // Restore A
                            Q <= {Q[N-2:0], 1'b0}; // Set quotient bit to 0
                        end else begin
                            Q <= {Q[N-2:0], 1'b1}; // Set quotient bit to 1
                        end
                        count <= count - 1;
                    end else begin
                        quotient <= Q;
                        remainder <= A;
                        done <= 1;
                        state <= IDLE;
                    end
                end
            endcase
        end
    end
endmodule