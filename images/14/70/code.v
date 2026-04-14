module restoring_divider (
    input clk,
    input rst,
    input [15:0] dividend,
    input [15:0] divisor,
    input start,
    output reg [15:0] quotient,
    output reg [15:0] remainder,
    output reg done
);
    reg [15:0] temp_dividend;
    reg [15:0] temp_quotient;
    reg [4:0] count; // To keep track of the number of bits processed
    reg [15:0] divisor_shifted;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            quotient <= 0;
            remainder <= 0;
            temp_dividend <= 0;
            temp_quotient <= 0;
            count <= 0;
            done <= 0;
        end else if (start) begin
            // Initialize values
            temp_dividend <= dividend;
            divisor_shifted <= divisor << 16; // Shift left to align
            temp_quotient <= 0;
            count <= 16;
            done <= 0;
        end else if (count > 0) begin
            // Restoring division process
            if (temp_dividend >= divisor_shifted) begin
                temp_dividend <= temp_dividend - divisor_shifted; // Subtract divisor
                temp_quotient <= (temp_quotient << 1) | 1; // Set quotient bit
            end else begin
                temp_dividend <= temp_dividend << 1; // Shift dividend
                temp_quotient <= temp_quotient << 1; // Shift quotient
            end
            divisor_shifted <= divisor_shifted >> 1; // Shift divisor right
            count <= count - 1; // Decrease bit count
        end else begin
            // Finalize the output
            quotient <= temp_quotient;
            remainder <= temp_dividend;
            done <= 1;
        end
    end
endmodule