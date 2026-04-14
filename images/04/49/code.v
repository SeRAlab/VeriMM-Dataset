module divider(
    input [7:0] dividend,
    input [7:0] divisor,
    output reg [7:0] quotient,
    output reg [7:0] remainder
);
    always @(*) begin
        if (divisor == 8'b00000000) begin
            quotient = 8'b00000000;
            remainder = dividend;
        end else begin
            quotient = dividend / divisor;
            remainder = dividend % divisor;
        end
    end
endmodule