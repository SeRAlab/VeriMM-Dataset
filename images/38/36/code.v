module restoring_divider(
    input clk,
    input rst,
    input [4:0] dividend,
    input [2:0] divisor,
    input start,
    output reg [4:0] quotient,
    output reg [1:0] remainder,
    output reg done
);
    reg [4:0] temp_dividend;
    reg [2:0] temp_divisor;
    reg [4:0] current_quotient;
    reg [3:0] count;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            quotient <= 5'b0;
            remainder <= 2'b0;
            done <= 1'b0;
            count <= 4'b0;
        end else if (start) begin
            temp_dividend <= dividend;
            temp_divisor <= divisor;
            current_quotient <= 5'b0;
            count <= 4'b0;
            done <= 1'b0;
        end else if (count < 5) begin
            current_quotient <= current_quotient << 1;
            current_quotient[0] <= temp_dividend[4];
            temp_dividend <= {temp_dividend[3:0], 1'b0};

            if (temp_dividend >= temp_divisor) begin
                temp_dividend <= temp_dividend - temp_divisor;
                current_quotient[0] <= 1'b1;
            end

            count <= count + 1;
        end else if (count == 5) begin
            quotient <= current_quotient;
            remainder <= temp_dividend[1:0];
            done <= 1'b1;
        end
    end
endmodule