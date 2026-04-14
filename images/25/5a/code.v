module restoring_divider (
    input clk,
    input rst,
    input [3:0] dividend,
    input [3:0] divisor,
    output reg [3:0] quotient,
    output reg [3:0] remainder,
    output reg done
);
    reg [3:0] A; // Accumulator
    reg [3:0] Q; // Quotient
    reg [3:0] M; // Divisor
    reg [3:0] count; // Count for iterations
    reg state; // State to indicate processing

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            A <= 4'b0000;
            Q <= 4'b0000;
            M <= divisor;
            quotient <= 4'b0000;
            remainder <= 4'b0000;
            done <= 0;
            count <= 4; // Number of bits for division
            state <= 1; // Start state
        end else if (state) begin
            if (count > 0) begin
                A <= {A[2:0], Q[3]}; // Shift left
                Q <= {Q[2:0], 1'b0}; // Shift left in Q
                A <= A - M; // Subtract divisor from A

                if (A[3] == 1) begin // A < 0
                    A <= A + M; // Restore A
                    Q[0] <= 0; // No change in Q
                end else begin
                    Q[0] <= 1; // Set Q bit
                end
                count <= count - 1; // Decrement count
            end else begin
                quotient <= Q;
                remainder <= A;
                done <= 1; // Indicate division is done
                state <= 0; // End state
            end
        end
    end
endmodule