module restoring_divider (
    input clk,
    input reset,
    input [4:0] dividend,
    input [2:0] divisor,
    output reg [4:0] quotient,
    output reg [1:0] remainder,
    output reg done
);
    reg [4:0] temp_dividend;
    reg [2:0] temp_divisor;
    reg [2:0] counter;
    reg [4:0] current_quotient;

    always @(posedge clk or posedge reset) begin
        if (reset) begin
            quotient <= 5'b0;
            remainder <= 2'b0;
            done <= 1'b0;
            counter <= 3'b0;
            current_quotient <= 5'b0;
        end else if (counter < 3'b101) begin
            temp_dividend <= {current_quotient[3:0], dividend[counter]};
            temp_divisor <= divisor;
            if (temp_dividend >= temp_divisor) begin
                temp_dividend <= temp_dividend - temp_divisor;
                current_quotient <= (current_quotient << 1) | 1'b1;
            end else begin
                current_quotient <= current_quotient << 1;
            end
            counter <= counter + 1;
        end else begin
            quotient <= current_quotient;
            remainder <= temp_dividend[1:0];
            done <= 1'b1;
        end
    end
endmodule