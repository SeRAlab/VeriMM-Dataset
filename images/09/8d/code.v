module divider (
    input wire clk,
    input wire [3:0] dividend,
    input wire [3:0] divisor,
    output reg [3:0] quotient,
    output reg [3:0] remainder,
    input wire start,
    output reg done
);
    reg [3:0] temp_dividend;
    reg [3:0] temp_divisor;
    reg [3:0] count;
    
    always @(posedge clk) begin
        if (start) begin
            temp_dividend <= dividend;
            temp_divisor <= divisor;
            count <= 0;
            done <= 0;
            quotient <= 0;
            remainder <= 0;
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