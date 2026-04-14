module divider_2bit (
    input [1:0] dividend,
    input [1:0] divisor,
    output reg [1:0] quotient,
    output reg remainder,
    output reg valid
);
    always @(*) begin
        if (divisor == 0) begin
            quotient = 2'b00;
            remainder = 1'b0;
            valid = 1'b0;
        end else begin
            quotient = dividend / divisor;
            remainder = dividend % divisor;
            valid = 1'b1;
        end
    end
endmodule