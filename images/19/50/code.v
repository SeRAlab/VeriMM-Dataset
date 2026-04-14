module divider (
    input [7:0] dividend,
    input [7:0] divisor,
    input start,
    input clk,
    input rst,
    output reg [7:0] quotient,
    output reg [7:0] remainder,
    output reg done
);
    reg [7:0] temp_dividend;
    reg [7:0] temp_divisor;
    reg [3:0] count;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            quotient <= 0;
            remainder <= 0;
            done <= 0;
            count <= 0;
        end else if (start) begin
            temp_dividend <= dividend;
            temp_divisor <= divisor;
            quotient <= 0;
            remainder <= 0;
            count <= 0;
            done <= 0;
        end else if (count < 8) begin
            if (temp_dividend >= temp_divisor) begin
                temp_dividend <= temp_dividend - temp_divisor;
                quotient <= quotient + 1;
            end
            count <= count + 1;
        end else begin
            remainder <= temp_dividend;
            done <= 1;
        end
    end
endmodule