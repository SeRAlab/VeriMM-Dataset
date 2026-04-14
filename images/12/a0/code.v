module divider_2bit (
    input [1:0] dividend,
    input [1:0] divisor,
    output reg [1:0] quotient,
    output reg [1:0] remainder,
    output reg error
);
    always @(*) begin
        if (divisor == 2'b00) begin
            quotient = 2'b00;
            remainder = 2'b00;
            error = 1'b1; // Indicate error
        end else begin
            quotient = dividend / divisor;
            remainder = dividend % divisor;
            error = 1'b0; // No error
        end
    end
endmodule