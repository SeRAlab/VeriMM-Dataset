module divider_4bit (
    input [3:0] dividend,
    input [3:0] divisor,
    output reg [3:0] quotient,
    output reg [3:0] remainder
);
    always @(*) begin
        if (divisor != 4'b0000) begin
            quotient = dividend / divisor;
            remainder = dividend % divisor;
        end else begin
            quotient = 4'b0000; // Undefined behavior, division by zero
            remainder = 4'b0000; // Undefined behavior, division by zero
        end
    end
endmodule