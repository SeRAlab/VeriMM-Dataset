module divider_8bit (
    input  [7:0] dividend,
    input  [7:0] divisor,
    output reg [7:0] quotient,
    output reg [7:0] remainder
);
    always @(*) begin
        if (divisor != 0) begin
            quotient = dividend / divisor;
            remainder = dividend % divisor;
        end else begin
            quotient = 8'b0;       // Undefined behavior, treat as zero
            remainder = dividend;   // remainder is dividend when divisor is zero
        end
    end
endmodule