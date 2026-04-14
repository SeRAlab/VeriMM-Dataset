module srt_divider (
    input [7:0] numerator,
    input [7:0] denominator,
    output reg [7:0] quotient,
    output reg [7:0] remainder
);
    always @(*) begin
        if (denominator == 0) begin
            quotient = 8'b0;
            remainder = numerator; // Avoid division by zero
        end else begin
            quotient = numerator / denominator; // Simple integer division
            remainder = numerator % denominator; // Remainder calculation
        end
    end
endmodule