module binary_divider (
    input [3:0] dividend,
    input [3:0] divisor,
    output reg [3:0] quotient,
    output reg [3:0] remainder);always @(*) begin
        quotient = dividend / divisor;
        remainder = dividend % divisor;
    end

endmodule