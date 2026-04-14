module non_restoring_divider(
    input clk,
    input rst,
    input [7:0] dividend,
    input [7:0] divisor,
    output reg [7:0] quotient,
    output reg [7:0] remainder,
    output reg done
);

reg [7:0] temp_dividend;
reg [7:0] temp_divisor;
reg [3:0] count;
reg [7:0] current_quotient;

always @(posedge clk or posedge rst) begin
    if (rst) begin
        quotient <= 0;
        remainder <= 0;
        done <= 0;
        count <= 0;
        current_quotient <= 0;
    end else if (count < 8) begin
        if (count == 0) begin
            temp_dividend <= dividend;
            temp_divisor <= divisor;
            current_quotient <= 0;
        end

        temp_dividend = {temp_dividend[6:0], 1'b0}; // Shift left
        current_quotient = {current_quotient[6:0], 1'b0}; // Shift left quotient

        if (temp_dividend >= temp_divisor) begin
            temp_dividend = temp_dividend - temp_divisor; // Subtract
            current_quotient[0] = 1; // Set LSB of quotient
        end

        count <= count + 1;
    end else begin
        quotient <= current_quotient;
        remainder <= temp_dividend;
        done <= 1; // Indicate that the operation is done
    end
end

endmodule