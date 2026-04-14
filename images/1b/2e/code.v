module restoring_divider(
    input clk,
    input start,
    input [7:0] dividend,
    input [7:0] divisor,
    output reg [7:0] quotient,
    output reg [7:0] remainder,
    output reg done
);
    reg [7:0] A; // Accumulator
    reg [7:0] Q; // Quotient
    reg [7:0] M; // Divisor
    reg [3:0] count; // Count for bit positions
    reg state; // State for operation

    initial begin
        done = 0;
        count = 0;
        quotient = 0;
        remainder = 0;
        A = 0;
        Q = 0;
        M = 0;
        state = 0;
    end

    always @(posedge clk) begin
        if (start) begin
            A = dividend;
            M = divisor;
            Q = 0;
            count = 8;
            done = 0;
            state = 1; // Start division
        end
        else if (state) begin
            A = {A[6:0], Q[7]}; // Shift A left
            Q = {Q[6:0], 1'b0}; // Shift Q left
            
            A = A - M; // Subtract divisor from A

            if (A[7] == 1) begin // If A < 0
                A = A + M; // Restore A
                Q[0] = 0; // Set LSB of Q to 0
            end else begin
                Q[0] = 1; // Set LSB of Q to 1
            end

            count = count - 1;

            if (count == 0) begin
                quotient = Q;
                remainder = A;
                done = 1;
                state = 0; // Division done
            end
        end
    end
endmodule