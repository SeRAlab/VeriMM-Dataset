module divider (
    input wire clk,
    input wire [3:0] dividend,
    input wire [3:0] divisor,
    input wire start,
    output reg [3:0] quotient,
    output reg [3:0] remainder,
    output reg done
);
    reg [3:0] count;
    reg [3:0] temp_dividend;
    reg [3:0] temp_quotient;

    always @(posedge clk) begin
        if (start) begin
            count <= 0;
            temp_dividend <= dividend;
            temp_quotient <= 0;
            done <= 0;
        end else if (count < 4) begin
            if (temp_dividend >= divisor) begin
                temp_dividend <= temp_dividend - divisor;
                temp_quotient <= temp_quotient + 1;
            end
            count <= count + 1;
        end else begin
            quotient <= temp_quotient;
            remainder <= temp_dividend;
            done <= 1;
        end
    end
endmodule