module SRT_Divider(
    input signed [7:0] dividend,
    input signed [7:0] divisor,
    output reg signed [7:0] quotient,
    output reg signed [7:0] remainder
);
    always @(*) begin
        if (divisor == 0) begin
            quotient = 0;
            remainder = dividend;
        end else begin
            quotient = dividend / divisor; // Integer division
            remainder = dividend % divisor; // Remainder
        end
    end
endmodule