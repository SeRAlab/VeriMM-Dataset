module divider_2bit (
    input clk,
    input rst,
    input enable,
    input [1:0] dividend,
    input [1:0] divisor,
    output reg [1:0] quotient,
    output reg [1:0] remainder
);
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            quotient <= 2'b00;
            remainder <= 2'b00;
        end else if (enable) begin
            if (divisor == 2'b00) begin
                quotient <= 2'b00;
                remainder <= 2'b00;
            end else begin
                quotient <= dividend / divisor;
                remainder <= dividend % divisor;
            end
        end
    end
endmodule