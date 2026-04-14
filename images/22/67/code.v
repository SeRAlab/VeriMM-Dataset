module divider_4bit (
    input [3:0] numerator,
    input [3:0] denominator,
    output reg [3:0] quotient,
    output reg [3:0] remainder
);
    always @(*) begin
        if (denominator == 4'b0000) begin
            quotient = 4'b1111; // Error code for division by zero
            remainder = 4'b1111; // Error code for division by zero
        end else begin
            quotient = numerator / denominator;
            remainder = numerator % denominator;
        end
    end
endmodule