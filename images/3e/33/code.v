module SRT_Divider (
    input [15:0] dividend,
    input [15:0] divisor,
    output reg [15:0] quotient,
    output reg [15:0] remainder
);
    integer i;
    reg [31:0] temp_dividend;
    reg [15:0] temp_quotient;

    always @(*) begin
        temp_dividend = {16'b0, dividend}; // Extend dividend to 32 bits
        temp_quotient = 0;
        remainder = dividend;

        for (i = 15; i >= 0; i = i - 1) begin
            temp_dividend = {remainder, 1'b0}; // Shift left
            if (temp_dividend >= divisor) begin
                temp_dividend = temp_dividend - divisor;
                temp_quotient = temp_quotient | (1'b1 << i);
            end
        end

        quotient = temp_quotient;
        remainder = temp_dividend[15:0]; // Get the remainder in the lower 16 bits
    end
endmodule