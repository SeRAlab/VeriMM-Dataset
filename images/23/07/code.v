module restoring_divider (
    input clk,
    input reset,
    input start,
    input [3:0] numerator,
    input [3:0] denominator,
    output reg [3:0] quotient,
    output reg [3:0] remainder,
    output reg done
);
    reg [3:0] A; // Accumulator
    reg [3:0] Q; // Quotient
    reg [3:0] M; // Divisor
    reg [2:0] count; // Counter

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            A <= 0;
            Q <= 0;
            M <= 0;
            count <= 0;
            done <= 0;
        end else if (start) begin
            A <= numerator;
            Q <= 0;
            M <= denominator;
            count <= 4; // 4 bits to process
            done <= 0;
        end else if (count > 0) begin
            // Shift left A and Q
            A <= {A[2:0], Q[3]};
            Q <= {Q[2:0], 1'b0};

            // Subtract M from A
            if (A >= M) begin
                A <= A - M;
                Q[0] <= 1'b1; // Set the least significant bit of quotient
            end else begin
                Q[0] <= 1'b0; // Do not set
            end
            
            count <= count - 1;
            // If count is 0, we are done
            if (count == 1) begin
                remainder <= A;
                quotient <= Q;
                done <= 1;
            end
        end
    end
endmodule