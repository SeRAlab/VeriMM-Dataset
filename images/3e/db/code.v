module restoring_divider (
    input clk,
    input rst,
    input [9:0] numerator,
    input [9:0] denominator,
    output reg [9:0] quotient,
    output reg [9:0] remainder,
    output reg done
);
    reg [9:0] current_numerator;
    reg [9:0] current_quotient;
    reg [9:0] divisor;
    integer count;

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            current_numerator <= 0;
            current_quotient <= 0;
            divisor <= denominator;
            count <= 0;
            done <= 0;
        end else begin
            if (count < 10) begin
                current_numerator <= {current_numerator[8:0], numerator[count]};
                if (current_numerator >= divisor) begin
                    current_numerator <= current_numerator - divisor;
                    current_quotient <= {current_quotient[8:0], 1'b1};
                end else begin
                    current_quotient <= {current_quotient[8:0], 1'b0};
                end
                count <= count + 1;
            end else begin
                quotient <= current_quotient;
                remainder <= current_numerator;
                done <= 1;
            end
        end
    end
endmodule