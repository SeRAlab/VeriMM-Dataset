module top_module(
    input [63:0] dividend,
    input [63:0] divisor,
    output reg [63:0] quotient,
    output reg [63:0] remainder
);always @(*) begin
        if (divisor == 0) begin
            quotient = 0;
            remainder = 0;
        end else begin
            quotient = dividend / divisor;
            remainder = dividend % divisor;
        end
    end

endmodule