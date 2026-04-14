module divider (
    input clk,
    input rst,
    input valid,
    input [7:0] numerator,
    input [7:0] denominator,
    output reg [7:0] quotient,
    output reg [7:0] remainder,
    output reg done
);
    reg [7:0] num;
    reg [7:0] denom;
    reg [7:0] temp_quotient;
    reg [7:0] temp_remainder;
    integer i;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            quotient <= 8'b0;
            remainder <= 8'b0;
            done <= 0;
            temp_quotient <= 8'b0;
            temp_remainder <= 8'b0;
            num <= 8'b0;
            denom <= 8'b0;
            i <= 0;
        end else if (valid) begin
            num <= numerator;
            denom <= denominator;
            temp_quotient <= 8'b0;
            temp_remainder <= num;
            done <= 0;
            for (i = 0; i < 8; i = i + 1) begin
                temp_remainder = {temp_remainder[6:0], 1'b0}; // Shift left
                temp_remainder[0] <= num[7 - i]; // Bring in the next bit of the numerator
                if (temp_remainder >= denom) begin
                    temp_remainder = temp_remainder - denom;
                    temp_quotient = {temp_quotient[6:0], 1'b1}; // Set the bit in quotient
                end else begin
                    temp_quotient = {temp_quotient[6:0], 1'b0}; // Clear the bit in quotient
                end
            end
            quotient <= temp_quotient;
            remainder <= temp_remainder;
            done <= 1; // Indicate that division is done
        end
    end
endmodule