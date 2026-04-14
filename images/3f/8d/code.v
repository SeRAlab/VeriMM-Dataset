module srt_divider(
    input [15:0] dividend,
    input [15:0] divisor,
    input start,
    output reg [15:0] quotient,
    output reg [15:0] remainder,
    output reg valid
);
    // Internal signals and states
    reg [15:0] temp_dividend;
    reg [15:0] temp_divisor;
    integer i;

    always @(*) begin
        valid = 0;
        quotient = 0;
        remainder = 0;

        if (start) begin
            temp_dividend = dividend;
            temp_divisor = divisor;
            quotient = 0;

            for (i = 15; i >= 0; i = i - 1) begin
                // Shift quotient left
                quotient = quotient << 1;

                // Subtract divisor from temp_dividend
                if (temp_dividend >= temp_divisor) begin
                    temp_dividend = temp_dividend - temp_divisor;
                    quotient[0] = 1; // Set the least significant bit of quotient
                end
            end
            
            remainder = temp_dividend;
            valid = 1; // Division is complete
        end
    end
endmodule