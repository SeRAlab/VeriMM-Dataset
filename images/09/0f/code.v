module non_restoring_divider (
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
        remainder = dividend;

        for (i = 0; i < 4; i = i + 1) begin
            temp_quotient = temp_quotient << 1; // Shift left quotient
            remainder = remainder << 1; // Shift left remainder
            remainder[0] = temp_dividend[3]; // Bring down the next bit

            temp_dividend = remainder - divisor; // Perform subtraction
            if (temp_dividend[3] == 1'b1) begin // If negative, restore
                temp_dividend = remainder; // Restore
                temp_quotient[0] = 0; // Set quotient bit to 0
            end else begin
                remainder = temp_dividend; // Update remainder
                temp_quotient[0] = 1; // Set quotient bit to 1
            end
        end

        quotient = temp_quotient;
    end
endmodule