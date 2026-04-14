module non_restoring_divider (
    input clk,
    input rst,
    input [15:0] dividend,
    input [15:0] divisor,
    output reg [15:0] quotient,
    output reg [15:0] remainder,
    output reg done
);
    reg [15:0] A; // accumulator
    reg [15:0] Q; // quotient register
    reg [15:0] M; // divisor
    reg [4:0] count; // counter for steps
    reg state; // state for process

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            A <= 16'b0;
            Q <= 16'b0;
            M <= divisor;
            remainder <= dividend;
            quotient <= 16'b0;
            count <= 0;
            done <= 0;
            state <= 0;
        end else if (count < 16) begin
            if (state == 0) begin
                // Shift left operation for A and Q
                A <= {A[14:0], Q[15]};
                Q <= {Q[14:0], 1'b0};
                state <= 1;
            end else begin
                // Subtraction step
                if (A >= M) begin
                    A <= A - M;
                    Q[0] <= 1;
                end else begin
                    Q[0] <= 0;
                end
                count <= count + 1;
                state <= 0;
            end
        end else begin
            quotient <= Q;
            remainder <= A;
            done <= 1;
        end
    end
endmodule