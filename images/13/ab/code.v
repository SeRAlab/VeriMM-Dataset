module non_restoring_divider (
    input [3:0] dividend,
    input [3:0] divisor,
    input start,
    output reg [3:0] quotient,
    output reg [3:0] remainder,
    output reg valid
);
    reg [7:0] temp_dividend;
    reg [3:0] temp_quotient;
    reg [3:0] temp_remainder;
    integer i;

    always @(*) begin
        if (start) begin
            temp_dividend = {4'b0000, dividend}; // Extend dividend
            temp_quotient = 4'b0000; // Initialize quotient
            valid = 0;

            if (divisor == 0) begin // Handle division by zero
                quotient = 4'b0000;
                remainder = 4'b0000;
                valid = 1;
            end else begin
                for (i = 3; i >= 0; i = i - 1) begin
                    temp_dividend = temp_dividend << 1; // Shift left
                    temp_dividend[0] = dividend[i]; // Bring down next bit

                    if (temp_dividend >= {4'b0000, divisor}) begin
                        temp_dividend = temp_dividend - {4'b0000, divisor}; // Subtract divisor
                        temp_quotient = temp_quotient | (1 << i); // Set bit in quotient
                    end
                end
                quotient = temp_quotient;
                remainder = temp_dividend[3:0];
                valid = 1;
            end
        end
    end
endmodule