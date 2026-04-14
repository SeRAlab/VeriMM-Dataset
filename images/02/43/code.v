module divider (
    input clk,
    input rst,
    input start,
    input [7:0] dividend,
    input [7:0] divisor,
    output reg [7:0] quotient,
    output reg [7:0] remainder,
    output reg done
);
    reg [7:0] temp_dividend;
    reg [7:0] temp_divisor;
    reg [3:0] count;
    reg [7:0] temp_quotient;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            quotient <= 8'b0;
            remainder <= 8'b0;
            done <= 0;
            count <= 4'b0;
        end else if (start) begin
            temp_dividend <= dividend;
            temp_divisor <= divisor;
            temp_quotient <= 8'b0;
            count <= 4'b1000; // 8 iterations for division
            done <= 0;
        end else if (count > 0) begin
            if (temp_dividend >= temp_divisor) begin
                temp_dividend <= temp_dividend - temp_divisor;
                temp_quotient <= temp_quotient + 1;
            end
            count <= count - 1;
        end else begin
            quotient <= temp_quotient;
            remainder <= temp_dividend;
            done <= 1;
        end
    end
endmodule