module divider_4bit (
    input wire clk,
    input wire reset,
    input wire start,
    input wire [3:0] dividend,
    input wire [3:0] divisor,
    output reg [3:0] quotient,
    output reg [3:0] remainder,
    output reg done
);
    reg [3:0] count;
    reg [3:0] temp_dividend;
    reg [3:0] temp_divisor;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            quotient <= 4'b0000;
            remainder <= 4'b0000;
            done <= 0;
            count <= 4'b0000;
        end else if (start) begin
            temp_dividend <= dividend;
            temp_divisor <= divisor;
            quotient <= 4'b0000;
            remainder <= temp_dividend;
            count <= 4'b0000;
            done <= 0;
        end else if (count < 4) begin
            remainder <= remainder - temp_divisor;
            if (remainder >= 0) begin
                quotient <= quotient + 1;
            end else begin
                remainder <= remainder + temp_divisor;
            end
            count <= count + 1;
        end else begin
            done <= 1;
        end
    end
endmodule