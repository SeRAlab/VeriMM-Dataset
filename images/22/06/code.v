module non_restoring_divider(
    input clk,
    input rst,
    input [7:0] dividend,
    input [7:0] divisor,
    output reg [7:0] quotient,
    output reg [7:0] remainder,
    output reg done
);

reg [7:0] A; // Accumulator
reg [7:0] Q; // Quotient
reg [3:0] count; // Counter for bit shifts
reg [1:0] state; // State variable

localparam IDLE = 2'b00,
           DIVIDE = 2'b01,
           DONE = 2'b10;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        A <= 8'b0;
        Q <= dividend;
        quotient <= 8'b0;
        remainder <= 8'b0;
        count <= 4'b0;
        state <= IDLE;
        done <= 1'b0;
    end else begin
        case (state)
            IDLE: begin
                if (divisor != 0) begin
                    A <= dividend;
                    Q <= 8'b0;
                    count <= 8; // Number of bits
                    state <= DIVIDE;
                end
            end
            DIVIDE: begin
                if (count > 0) begin
                    // Shift left A and Q
                    A <= {A[6:0], Q[7]};
                    Q <= {Q[6:0], 1'b0};
                    // Subtract divisor from A
                    A = A - divisor;
                    if (A[7] == 1) begin // if A < 0
                        // A is negative, set LSB of Q to 0
                        A <= {A[7], A[6:0]};
                        Q[0] <= 0;
                    end else begin
                        // A is positive, set LSB of Q to 1
                        Q[0] <= 1;
                    end
                    count <= count - 1;
                end else begin
                    quotient <= Q;
                    remainder <= A;
                    done <= 1'b1;
                    state <= DONE;
                end
            end
            DONE: begin
                done <= 1'b1; // Signal that division is done
            end
        endcase
    end
end

endmodule