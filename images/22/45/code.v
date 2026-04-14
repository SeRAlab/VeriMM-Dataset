module divider_2bit (
    input [1:0] dividend,
    input [1:0] divisor,
    output reg [1:0] quotient,
    output reg [1:0] remainder
);
    always @(*) begin
        if (divisor == 2'b00) begin
            quotient = 2'b00; // Undefined behavior, can be zeroed or set to some error value
            remainder = 2'b00; // Undefined behavior
        end else begin
            quotient = dividend / divisor;
            remainder = dividend % divisor;
        end
    end
endmodule