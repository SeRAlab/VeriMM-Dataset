module non_restoring_divider(
    input clk,
    input rst,
    input [4:0] dividend,
    input [2:0] divisor,
    output reg [4:0] quotient,
    output reg [1:0] remainder,
    output reg done
);
    reg [4:0] A; // Accumulator
    reg [2:0] B; // Divisor
    reg [3:0] count; // Count of bits processed
    reg [4:0] temp_quotient;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            A <= 5'b0;
            B <= 3'b0;
            quotient <= 5'b0;
            remainder <= 2'b0;
            count <= 4'b0;
            done <= 0;
            temp_quotient <= 5'b0;
        end else if (count < 5) begin
            if (count == 0) begin
                A <= dividend;
                B <= divisor;
                temp_quotient <= 5'b0;
            end
            
            A <= {A[3:0], 1'b0}; // Shift left A (append bit)
            if (A >= {2'b00, B}) begin // If A >= B
                A <= A - {2'b00, B}; // Subtract B from A
                temp_quotient <= {temp_quotient[3:0], 1'b1}; // Set quotient bit
            end else begin
                temp_quotient <= {temp_quotient[3:0], 1'b0}; // Clear quotient bit
            end
            
            count <= count + 1; // Increment count
        end else begin
            quotient <= temp_quotient; // Set the final quotient
            remainder <= A[1:0]; // Set the remainder
            done <= 1; // Indicate done
        end
    end
endmodule