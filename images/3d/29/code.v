module divider_2bit (
    input [1:0] numerator,
    input [1:0] denominator,
    output reg quotient,
    output reg [1:0] remainder
);
    always @(*) begin
        if (denominator == 2'b00) begin
            quotient = 1'b0; // Avoid division by zero
            remainder = numerator; // Remainder is the numerator
        end else begin
            quotient = numerator / denominator;
            remainder = numerator % denominator;
        end
    end
endmodule