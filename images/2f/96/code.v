module restoring_divider (
    input clk,
    input rst,
    input [15:0] dividend,
    input [7:0] divisor,
    output reg [15:0] quotient,
    output reg [7:0] remainder,
    output reg done
);
    reg [15:0] A; // The register that holds the current value of the dividend
    reg [7:0] Q;  // The quotient register
    reg [7:0] D;  // The divisor
    integer i;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            A <= 16'b0;
            Q <= 8'b0;
            remainder <= 8'b0;
            quotient <= 16'b0;
            done <= 0;
            i <= 0;
        end else begin
            if (i < 8) begin
                // Shift left A and Q
                A <= {A[14:0], 1'b0}; // Shift A left
                A[0] <= Q[7];         // LSB of A gets the LSB of Q
                Q <= {Q[6:0], 1'b0};  // Shift Q left
                // Subtract divisor from A
                A = A - {8'b0, divisor};

                if (A[15] == 1'b1) begin
                    // If the result is negative, restore A and set the LSB of Q to 0
                    A = A + {8'b0, divisor};
                    Q[0] = 1'b0;
                end else begin
                    // If the result is non-negative, set the LSB of Q to 1
                    Q[0] = 1'b1;
                end

                i = i + 1; // Increment counter
            end else if (i == 8) begin
                // Finished division
                quotient <= Q;
                remainder <= A[7:0];
                done <= 1;
            end
        end
    end
endmodule