module divider (
    input [7:0] dividend,
    input [7:0] divisor,
    input clk,
    input rst,
    output reg [7:0] quotient,
    output reg [7:0] remainder
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            quotient <= 8'b0;
            remainder <= 8'b0;
        end else begin
            if (divisor != 8'b0) begin
                quotient <= dividend / divisor;
                remainder <= dividend % divisor;
            end else begin
                quotient <= 8'b0;
                remainder <= 8'b0;
            end
        end
    end
endmodule