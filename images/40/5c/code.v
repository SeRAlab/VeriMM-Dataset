module divider (
    input [7:0] dividend,
    input [7:0] divisor,
    output reg [7:0] quotient,
    output reg [7:0] remainder
);
    always @(*) begin
        if (divisor != 0) begin
            quotient = dividend / divisor;
            remainder = dividend % divisor;
        end else begin
            quotient = 8'hFF; // Indicate error for division by zero
            remainder = 8'hFF; // Indicate error for division by zero
        end
    end
endmodule