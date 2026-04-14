module restoring_divider (
    input clk,
    input reset,
    input start,
    input [15:0] dividend,
    input [15:0] divisor,
    output reg [15:0] quotient,
    output reg [15:0] remainder,
    output reg done
);
    reg [15:0] A; // Accumulator
    reg [15:0] Q; // Quotient
    reg [15:0] M; // Divisor
    reg [4:0] count; // Counter
    reg state; // State variable

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            A <= 0;
            Q <= 0;
            M <= 0;
            count <= 0;
            done <= 0;
            quotient <= 0;
            remainder <= 0;
            state <= 0;
        end else if (start) begin
            A <= dividend;
            Q <= 0;
            M <= divisor;
            count <= 16;
            state <= 1;
            done <= 0;
        end else if (state) begin
            if (count > 0) begin
                A <= {A[14:0], Q[15]}; // Shift left
                Q <= {Q[14:0], 1'b1}; // Set the next bit to 1
                if (A >= M) begin
                    A <= A - M; // Subtract divisor
                end else begin
                    Q <= {Q[14:0], 1'b0}; // Set the next bit to 0
                    A <= {A[14:0], Q[15]}; // Restore A
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