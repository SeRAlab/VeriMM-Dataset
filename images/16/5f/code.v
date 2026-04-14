module restoring_divider (
    input wire clk,
    input wire reset,
    input wire [15:0] dividend,
    input wire [15:0] divisor,
    output reg [15:0] quotient,
    output reg [15:0] remainder,
    output reg done
);
    reg [15:0] A; // Accumulator
    reg [15:0] Q; // Quotient
    reg [15:0] M; // Divisor
    reg [4:0] count; // Count for the number of bits

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            A <= 0;
            Q <= 0;
            count <= 0;
            done <= 0;
            remainder <= 0;
            quotient <= 0;
        end else if (count < 16) begin
            if (count == 0) begin
                M <= divisor; // Load divisor
                A <= dividend; // Load dividend
            end
            
            // Left shift A and Q
            A <= {A[14:0], Q[15]};
            Q <= {Q[14:0], 1'b0};
            
            // Subtract
            A <= A - M;

            if (A[15] == 1) begin // If A is negative
                A <= A + M; // Restore A
                Q[0] <= 0; // Set LSB of Q to 0
            end else begin
                Q[0] <= 1; // Set LSB of Q to 1
            end
            
            count <= count + 1;
        end else begin
            remainder <= A;
            quotient <= Q;
            done <= 1; // Indicate completion
        end
    end
endmodule