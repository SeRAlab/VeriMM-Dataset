module srt_divider (
    input clk,
    input rst,
    input start,
    input [15:0] dividend,
    input [15:0] divisor,
    output reg [15:0] quotient,
    output reg [15:0] remainder,
    output reg done
);
    reg [15:0] A, Q, M;
    reg [4:0] count;
    reg state;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            A <= 16'b0;
            Q <= 16'b0;
            M <= 16'b0;
            quotient <= 16'b0;
            remainder <= 16'b0;
            done <= 0;
            count <= 5'b0;
            state <= 0;
        end else if (start) begin
            A <= dividend;
            M <= divisor;
            Q <= 16'b0;
            count <= 5'd16;
            state <= 1;
            done <= 0;
        end else if (state) begin
            if (count > 0) begin
                A <= {A[14:0], Q[15]};
                Q <= Q << 1;
                if (A >= M) begin
                    A <= A - M;
                    Q[0] <= 1;
                end else begin
                    Q[0] <= 0;
                end
                count <= count - 1;
            end else begin
                quotient <= Q;
                remainder <= A;
                done <= 1;
                state <= 0;
            end
        end
    end
endmodule