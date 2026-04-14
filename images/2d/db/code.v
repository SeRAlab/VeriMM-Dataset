module divider_2bit(
    input [1:0] numerator,
    input [1:0] denominator,
    output reg [1:0] quotient,
    output reg [1:0] remainder
);
    always @(*) begin
        if (denominator == 2'b00) begin
            quotient = 2'b00;
            remainder = 2'b00;
        end else begin
            quotient = numerator / denominator;
            remainder = numerator % denominator;
        end
    end
endmodule