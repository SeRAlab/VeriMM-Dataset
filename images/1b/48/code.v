module divider (
    input [7:0] dividend,
    input [7:0] divisor,
    input clk,
    input start,
    output reg [7:0] quotient,
    output reg [7:0] remainder,
    output reg done
);
    reg [7:0] count;
    reg [15:0] temp_dividend;

    always @(posedge clk) begin
        if (start) begin
            quotient <= 0;
            remainder <= dividend;
            count <= 8; // Number of bits to process
            done <= 0;
        end else if (count > 0) begin
            temp_dividend = {remainder[7], remainder}; // Shift remainder
            if (temp_dividend >= divisor) begin
                temp_dividend = temp_dividend - {8'b0, divisor}; // Subtract divisor
                quotient = {quotient[6:0], 1'b1}; // Set quotient bit
            end else begin
                quotient = {quotient[6:0], 1'b0}; // Clear quotient bit
            end
            remainder <= temp_dividend[7:0]; // Update remainder
            count <= count - 1; // Decrement bit count
        end else begin
            done <= 1; // Indicate operation is done
        end
    end
endmodule