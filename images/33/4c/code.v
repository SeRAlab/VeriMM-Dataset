module divider (
    input clk,
    input rst,
    input [7:0] dividend,
    input [7:0] divisor,
    output reg [7:0] quotient,
    output reg [7:0] remainder,
    output reg done
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            quotient <= 8'b0;
            remainder <= 8'b0;
            done <= 0;
        end else begin
            if (divisor != 0) begin
                quotient <= dividend / divisor;
                remainder <= dividend % divisor;
                done <= 1;
            end else begin
                quotient <= 8'b0;
                remainder <= dividend; // handle division by zero by returning dividend as remainder
                done <= 1;
            end
        end
    end
endmodule