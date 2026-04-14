module non_restoring_divider (
    input [7:0] dividend,
    input [7:0] divisor,
    output reg [7:0] quotient,
    output reg [7:0] remainder
);
    reg [7:0] temp_dividend;
    reg [7:0] temp_remainder;
    integer i;

    always @(*) begin
        temp_dividend = dividend;
        temp_remainder = 8'b0;
        quotient = 8'b0;
        
        // Non-restoring division algorithm
        for (i = 7; i >= 0; i = i - 1) begin
            temp_remainder = {temp_remainder[6:0], temp_dividend[i]};
            if (temp_remainder >= divisor) begin
                temp_remainder = temp_remainder - divisor;
                quotient = {quotient[6:0], 1'b1};
            end else begin
                quotient = {quotient[6:0], 1'b0};
            end
        end
        remainder = temp_remainder;
    end
endmodule