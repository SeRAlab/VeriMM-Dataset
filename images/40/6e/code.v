module divider_8bit (
    input [7:0] dividend,
    input [7:0] divisor,
    output reg [7:0] quotient,
    output reg [7:0] remainder
);
    always @(*) begin
        if (divisor == 0) begin
            quotient = 8'hFF; // Indicate error (division by zero)
            remainder = 8'hFF; // Indicate error (division by zero)
        end else begin
            quotient = dividend / divisor;
            remainder = dividend % divisor;
        end
    end
endmodule