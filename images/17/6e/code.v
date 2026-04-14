module srt_divider (
    input [3:0] dividend,
    input [3:0] divisor,
    output reg [3:0] quotient,
    output reg [3:0] remainder
);
    reg [3:0] temp_dividend;
    reg [3:0] temp_quotient;
    integer i;

    always @(*) begin
        temp_dividend = dividend;
        temp_quotient = 4'b0000;
        remainder = 4'b0000;

        for (i = 0; i < 4; i = i + 1) begin
            temp_dividend = {temp_dividend[2:0], 1'b0}; // Shift left
            remainder = temp_dividend - divisor; // Subtract divisor
            
            if (~remainder[3]) begin // If remainder is positive
                temp_quotient = {temp_quotient[2:0], 1'b1}; // Set next quotient bit
                temp_dividend = remainder; // Update dividend
            end else begin
                temp_quotient = {temp_quotient[2:0], 1'b0}; // Keep quotient bit as 0
                remainder = temp_dividend; // Keep original dividend as remainder
            end
        end
        
        quotient = temp_quotient;
        remainder = temp_dividend;
    end
endmodule