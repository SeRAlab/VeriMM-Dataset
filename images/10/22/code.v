module divider (
    input clk,
    input reset,
    input start,
    input [7:0] dividend,
    input [7:0] divisor,
    output reg [7:0] quotient,
    output reg [7:0] remainder,
    output reg done
);
    reg [7:0] temp_dividend;
    reg [7:0] temp_quotient;
    reg [3:0] count;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            quotient <= 8'b0;
            remainder <= 8'b0;
            done <= 1'b0;
            count <= 4'b0;
        end else if (start) begin
            temp_dividend <= dividend;
            temp_quotient <= 8'b0;
            count <= 4'b0;
            done <= 1'b0;
        end else if (count < 8) begin
            temp_quotient <= {temp_quotient[6:0], 1'b0}; // Shift left
            temp_dividend <= {temp_dividend[6:0], 1'b0}; // Shift left
            if (temp_dividend >= divisor) begin
                temp_dividend <= temp_dividend - divisor; // Subtract divisor
                temp_quotient[0] <= 1'b1; // Set LSB of quotient
            end
            count <= count + 1;
        end else if (count == 8) begin
            quotient <= temp_quotient; // Final quotient
            remainder <= temp_dividend; // Final remainder
            done <= 1'b1; // Indicate completion
        end
    end
endmodule