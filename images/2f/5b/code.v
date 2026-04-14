module non_restoring_divider (
    input [7:0] numerator,
    input [7:0] denominator,
    input clk,
    input start,
    output reg [7:0] quotient,
    output reg [7:0] remainder,
    output reg done
);

    reg [15:0] temp_numerator;
    reg [7:0] temp_denominator;
    reg [3:0] count;

    always @(posedge clk) begin
        if (start) begin
            temp_numerator = {8'b0, numerator}; // Extend numerator
            temp_denominator = denominator;
            quotient = 0;
            remainder = 0;
            count = 8; // Number of bits
            done = 0;
        end else if (count > 0) begin
            // Shift left operation
            temp_numerator = temp_numerator << 1;
            quotient = quotient << 1;

            // Subtract
            if (temp_numerator >= {8'b0, temp_denominator}) begin
                temp_numerator = temp_numerator - {8'b0, temp_denominator};
                quotient[0] = 1; // Set LSB of quotient
            end

            count = count - 1;
        end else begin
            remainder = temp_numerator[7:0]; // Remainder is the lower part
            done = 1; // Division complete
        end
    end
endmodule