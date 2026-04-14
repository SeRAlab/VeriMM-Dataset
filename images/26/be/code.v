module non_restoring_divider (
    input [3:0] dividend,
    input [3:0] divisor,
    output reg [3:0] quotient,
    output reg [3:0] remainder
);
    reg [3:0] temp_dividend;
    reg [4:0] temp_remainder;
    integer i;

    always @(*) begin
        temp_dividend = dividend;
        temp_remainder = 0;
        quotient = 0;

        for (i = 0; i < 4; i = i + 1) begin
            temp_remainder = {temp_remainder[3:0], temp_dividend[3]};
            temp_dividend = {temp_dividend[2:0], 1'b0}; // Shift left

            if (temp_remainder >= divisor) begin
                temp_remainder = temp_remainder - divisor; // Subtract
                quotient[i] = 1;
            end else begin
                quotient[i] = 0;
            end
        end

        remainder = temp_remainder[3:0];
    end
endmodule