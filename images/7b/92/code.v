module top_module(
    input signed [31:0] A,
    input signed [31:0] B,
    input start,
    output reg signed [31:0] result
);reg signed [31:0] dividend;
reg signed [31:0] divisor;
reg signed [31:0] quotient;
reg [31:0] abs_dividend;
reg [31:0] abs_divisor;
reg signed sign;

always @ (start or A or B) begin
    if (start) begin
        dividend = A;
        divisor = B;
        abs_dividend = (dividend < 0) ? -dividend : dividend;
        abs_divisor = (divisor < 0) ? -divisor : divisor;
        sign = (A < 0) ^ (B < 0) ? -1 : 1;
        quotient = sign * (abs_dividend / abs_divisor);
        result <= quotient;
    end
end

endmodule