module divider(
    input clk,
    input rst,
    input [7:0] dividend,
    input [7:0] divisor,
    input start,
    output reg [7:0] quotient,
    output reg [7:0] remainder,
    output reg ready
);
    reg [7:0] count;
    reg [15:0] temp_dividend;
    reg [7:0] temp_divisor;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            quotient <= 8'b0;
            remainder <= 8'b0;
            ready <= 1'b0;
            count <= 8'b0;
            temp_dividend <= 16'b0;
            temp_divisor <= 8'b0;
        end else if (start) begin
            temp_dividend <= {8'b0, dividend}; // Load dividend
            temp_divisor <= divisor; // Load divisor
            quotient <= 8'b0;
            remainder <= 8'b0;
            count <= 8; // Set counter for 8 bits
            ready <= 1'b0;
        end else if (count > 0) begin
            temp_dividend = {remainder, 1'b0}; // Shift left remainder
            remainder <= temp_dividend - temp_divisor; // Subtract divisor
            
            if (remainder >= 8'b0) begin
                remainder <= remainder; // Update remainder
                quotient <= (quotient << 1) | 1'b1; // Set quotient bit
            end else begin
                remainder <= temp_dividend; // Restore remainder
                quotient <= quotient << 1; // Shift left quotient
            end
            
            count <= count - 1; // Decrement counter
        end else begin
            ready <= 1'b1; // Operation complete
        end
    end
endmodule