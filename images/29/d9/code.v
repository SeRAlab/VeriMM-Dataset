module srt_divider(
    input [15:0] dividend,
    input [15:0] divisor,
    output reg [15:0] quotient,
    output reg [15:0] remainder
);
    reg [15:0] temp_dividend;
    reg signed [15:0] estimate;
    integer i;

    always @(*) begin
        temp_dividend = dividend;
        quotient = 16'd0;
        remainder = dividend;

        for (i = 0; i < 16; i = i + 1) begin
            estimate = (remainder >= divisor) ? 16'd1 : 16'd0;
            quotient = (quotient << 1) | estimate;
            remainder = (remainder - (estimate * divisor)) << 1;
        end
    end
endmodule