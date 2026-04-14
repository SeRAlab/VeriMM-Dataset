module srt_divider(
    input [7:0] dividend,
    input [7:0] divisor,
    output reg [7:0] quotient,
    output reg [7:0] remainder
);
    reg [15:0] temp_dividend;
    reg [7:0] temp_quotient;
    integer i;

    always @(*) begin
        temp_dividend = {8'b0, dividend}; // Extend dividend
        temp_quotient = 8'b0; // Clear quotient
        remainder = dividend; // Initialize remainder

        for (i = 7; i >= 0; i = i - 1) begin
            temp_dividend = {temp_dividend[14:0], 1'b0}; // Shift left
            temp_dividend[0] = remainder[7]; // Handle the next bit of remainder
            remainder = remainder << 1; // Shift left remainder

            if (temp_dividend >= {1'b0, divisor}) begin
                temp_dividend = temp_dividend - {1'b0, divisor}; // Subtract divisor
                temp_quotient = temp_quotient | (1'b1 << i); // Set quotient bit
            end
        end
        quotient = temp_quotient; // Assign final quotient
        remainder = temp_dividend[7:0]; // Assign final remainder
    end
endmodule