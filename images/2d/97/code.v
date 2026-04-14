module non_restoring_divider (
    input [3:0] dividend,
    input [3:0] divisor,
    output reg [3:0] quotient,
    output reg [3:0] remainder,
    input clk,
    input start,
    output reg done
);
    reg [4:0] temp_dividend;
    reg [4:0] temp_divisor;
    reg [3:0] count;
    
    always @(posedge clk) begin
        if (start) begin
            temp_dividend = {1'b0, dividend}; // Extend the dividend
            temp_divisor = {1'b0, divisor};   // Extend the divisor
            quotient = 4'b0;
            remainder = 4'b0;
            count = 4; // number of bits
            done = 0;
        end else begin
            if (count > 0) begin
                // Shift left the quotient
                quotient = {quotient[2:0], 1'b0};
                temp_dividend = {temp_dividend[3:0], 1'b0}; // Shift dividend
                if (temp_dividend >= temp_divisor) begin
                    temp_dividend = temp_dividend - temp_divisor; // Subtract
                    quotient[0] = 1; // Set LSB of quotient
                end
                // Shift remainder
                remainder = temp_dividend[3:0];
                count = count - 1;
            end else begin
                done = 1; // Division complete
            end
        end
    end
endmodule