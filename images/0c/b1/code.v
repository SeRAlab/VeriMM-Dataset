module divider_4bit (
    input [3:0] dividend,
    input [3:0] divisor,
    input clk,
    input rst,
    output reg [3:0] quotient,
    output reg [3:0] remainder
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            quotient <= 4'b0000;
            remainder <= 4'b0000;
        end else if (divisor != 4'b0000) begin
            quotient <= dividend / divisor;
            remainder <= dividend % divisor;
        end else begin
            quotient <= 4'b0000;
            remainder <= 4'b0000;
        end
    end
endmodule