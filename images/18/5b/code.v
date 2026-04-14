module two_bit_divider (
    input [1:0] numerator,
    input [1:0] denominator,
    output reg [1:0] quotient,
    output reg remainder,
    input clk,
    input rst
);
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            quotient <= 2'b00;
            remainder <= 1'b0;
        end else begin
            if (denominator == 2'b00) begin
                quotient <= 2'b00;  // default value for division by zero
                remainder <= 1'b0;
            end else begin
                quotient <= numerator / denominator;
                remainder <= numerator % denominator;
            end
        end
    end
endmodule