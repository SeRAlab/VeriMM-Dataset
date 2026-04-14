module restoring_divider (
    input clk,
    input rst,
    input [3:0] dividend,
    input [1:0] divisor,
    output reg [1:0] quotient,
    output reg [1:0] remainder,
    output reg done
);
    reg [3:0] temp_dividend;
    reg [1:0] temp_quotient;
    reg [3:0] subtractor;
    reg [1:0] count;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            quotient <= 2'b00;
            remainder <= 2'b00;
            done <= 0;
            count <= 2'b00;
            temp_dividend <= 4'b0000;
            temp_quotient <= 2'b00;
        end else begin
            if (count < 2) begin
                temp_dividend = (temp_dividend << 1) | dividend[count];
                subtractor = divisor << (1 - count);
                if (temp_dividend >= subtractor) begin
                    temp_dividend = temp_dividend - subtractor;
                    temp_quotient = (temp_quotient << 1) | 1'b1;
                end else begin
                    temp_quotient = (temp_quotient << 1);
                end
                count <= count + 1;
            end else begin
                quotient <= temp_quotient;
                remainder <= temp_dividend[3:2];
                done <= 1;
            end
        end
    end
endmodule