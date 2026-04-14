module non_restoring_divider (
    input clk,
    input rst,
    input start,
    input [7:0] dividend,
    input [7:0] divisor,
    output reg [7:0] quotient,
    output reg [7:0] remainder,
    output reg done
);
    reg [7:0] A; // Dividend
    reg [7:0] Q; // Quotient
    reg [7:0] M; // Divisor
    reg [4:0] count; // Count for iterations

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            A <= 0;
            Q <= 0;
            M <= 0;
            count <= 0;
            done <= 0;
            quotient <= 0;
            remainder <= 0;
        end else if (start) begin
            A <= dividend;
            Q <= 0;
            M <= divisor;
            count <= 8; // number of bits
            done <= 0;
        end else if (count > 0) begin
            // Shift left operation
            A <= {A[6:0], Q[7]};
            Q <= {Q[6:0], 1'b0};
            A <= A - M; // Subtract M from A
            
            if (A[7] == 1) begin // If A is negative
                A <= A + M; // Restore A
                Q[0] <= 0; // Set Q least significant bit to 0
            end else begin
                Q[0] <= 1; // Set Q least significant bit to 1
            end
            
            count <= count - 1; // Decrement the count
        end else if (count == 0) begin
            quotient <= Q;
            remainder <= A;
            done <= 1; // Division completed
        end
    end
endmodule