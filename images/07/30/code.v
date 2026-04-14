module divider_4bit (
    input [3:0] dividend,
    input [3:0] divisor,
    output reg [3:0] quotient,
    output reg [3:0] remainder
);
    always @* begin
        if (divisor == 4'b0000) begin
            // Division by zero case
            quotient = 4'b1111; // Error value for quotient
            remainder = 4'b1111; // Error value for remainder
        end else begin
            quotient = dividend / divisor;
            remainder = dividend % divisor;
        end
    end
endmodule