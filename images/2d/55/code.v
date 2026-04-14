module non_restoring_divider(
    input [3:0] dividend,
    input [3:0] divisor,
    output reg [3:0] quotient
);
    reg [4:0] remainder;
    integer i;

    always @(*) begin
        remainder = 0;
        quotient = 0;

        for (i = 3; i >= 0; i = i - 1) begin
            remainder = {remainder[3:0], dividend[i]};
            if (remainder >= divisor) begin
                remainder = remainder - divisor;
                quotient[i] = 1;
            end else begin
                quotient[i] = 0;
            end
        end
    end
endmodule