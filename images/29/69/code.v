module non_restoring_divider(
    input [3:0] dividend,
    input [3:0] divisor,
    input start,
    output reg [3:0] quotient,
    output reg [3:0] remainder,
    output reg done
);
    reg [3:0] temp_dividend;
    reg [4:0] temp_remainder;
    integer i;

    always @(*) begin
        if (start) begin
            temp_dividend = dividend;
            temp_remainder = 0;
            quotient = 0;
            done = 0;
            for (i = 0; i < 4; i = i + 1) begin
                temp_remainder = {temp_remainder[3:0], temp_dividend[i]};
                if (temp_remainder >= divisor) begin
                    temp_remainder = temp_remainder - divisor;
                    quotient = {quotient[2:0], 1'b1};
                end else begin
                    quotient = {quotient[2:0], 1'b0};
                end
            end
            remainder = temp_remainder[3:0];
            done = 1;
        end else begin
            quotient = 0;
            remainder = 0;
            done = 0;
        end
    end
endmodule