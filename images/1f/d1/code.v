module divider (
    input clk,
    input reset,
    input start,
    input [3:0] dividend,
    input [3:0] divisor,
    output reg [3:0] quotient,
    output reg [3:0] remainder,
    output reg done
);
    reg [3:0] temp_dividend;
    reg [3:0] temp_divisor;
    reg [2:0] count; // Counter to track the division steps

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            quotient <= 4'b0000;
            remainder <= 4'b0000;
            done <= 0;
            count <= 3'b000;
        end else if (start) begin
            if (divisor == 4'b0000) begin // Handle division by zero
                quotient <= 4'b0000;
                remainder <= dividend;
                done <= 1;
            end else begin
                temp_dividend <= dividend;
                temp_divisor <= divisor;
                quotient <= 4'b0000;
                remainder <= 4'b0000;
                count <= 3'b000;
                done <= 0;
            end
        end else if (count < 4) begin
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