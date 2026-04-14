module SRT_Divider (
    input [15:0] dividend,
    input [15:0] divisor,
    output reg [15:0] quotient,
    output reg [15:0] remainder
);
    reg [15:0] temp_dividend;
    reg [15:0] temp_quotient;
    integer i;

    always @(*) begin
        // Initial values
        temp_dividend = dividend;
        temp_quotient = 0;
        remainder = dividend;

        // SRT division algorithm
        for (i = 0; i < 16; i = i + 1) begin
            // Shift left quotient
            temp_quotient = {temp_quotient[14:0], 1'b0};
            remainder = {remainder[14:0], 1'b0};
            remainder = remainder - divisor;

            // Check if remainder is negative
            if (remainder[15] == 1) begin
                remainder = remainder + divisor; // Restore remainder
                temp_quotient[0] = 0; // Set the LSB of quotient to 0
            end else begin
                // Remainder is positive
                temp_quotient[0] = 1; // Set the LSB of quotient to 1
            end
        end
        quotient = temp_quotient;
    end
endmodule