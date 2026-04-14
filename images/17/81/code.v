module SRT_Divider(
    input [7:0] numerator,
    input [7:0] denominator,
    output reg [7:0] quotient,
    output reg [7:0] remainder
);

    always @(*) begin
        if (denominator == 0) begin
            quotient = 8'b0; // Avoid division by zero
            remainder = numerator; // Remainder is the numerator if denominator is zero
        end else begin
            quotient = numerator / denominator; // Simple integer division
            remainder = numerator % denominator; // Remainder of the division
        end
    end
endmodule