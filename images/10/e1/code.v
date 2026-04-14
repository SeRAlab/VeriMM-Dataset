module divider (
    input clk,
    input rst,
    input [3:0] dividend,
    input [3:0] divisor,
    output reg [3:0] quotient,
    output reg [3:0] remainder,
    output reg done
);
    reg [3:0] count;
    reg [3:0] temp_dividend;
    reg [3:0] temp_quotient;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            quotient <= 0;
            remainder <= 0;
            count <= 0;
            temp_dividend <= 0;
            temp_quotient <= 0;
            done <= 0;
        end else begin
            if (count < 4) begin
                temp_dividend <= {remainder, dividend[3-count]};
                if (temp_dividend >= divisor) begin
                    temp_dividend <= temp_dividend - divisor;
                    temp_quotient[count] <= 1;
                end else begin
                    temp_quotient[count] <= 0;
                end
                remainder <= temp_dividend;
                count <= count + 1;
            end else begin
                quotient <= temp_quotient;
                done <= 1;
            end
        end
    end
endmodule