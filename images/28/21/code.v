module divider_2bit (
    input [1:0] dividend,
    input [1:0] divisor,
    output reg [1:0] quotient,
    output reg remainder
);
    always @(*) begin
        if (divisor == 2'b00) begin
            quotient = 2'bxx;  // Undefined output
            remainder = 1'bx;  // Undefined output
        end else begin
            quotient = dividend / divisor;
            remainder = dividend % divisor;
        end
    end
endmodule