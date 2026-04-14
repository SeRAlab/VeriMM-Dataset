module SRT_Divider (
    input [15:0] dividend,
    input [7:0] divisor,
    output reg [15:0] quotient,
    output reg [15:0] remainder
);
    reg [15:0] temp_dividend;
    reg [7:0] temp_divisor;
    integer i;

    always @(*) begin
        temp_dividend = dividend;
        temp_divisor = divisor;
        quotient = 0;
        remainder = 0;

        for (i = 15; i >= 0; i = i - 1) begin
            remainder = {remainder[14:0], temp_dividend[i]};
            if (remainder >= temp_divisor) begin
                remainder = remainder - temp_divisor;
                quotient = {quotient[14:0], 1'b1};
            end else begin
                quotient = {quotient[14:0], 1'b0};
            end
        end
    end
endmodule