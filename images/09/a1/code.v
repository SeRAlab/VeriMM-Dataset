module SRT_Divider (
    input [4:0] dividend,
    input [4:0] divisor,
    output reg [4:0] quotient,
    output reg [4:0] remainder
);
    always @(*) begin
        if (divisor == 5'b00000) begin
            quotient = 5'b00000; // Handle division by zero
            remainder = 5'b00000;
        end else begin
            quotient = dividend / divisor; // Integer division
            remainder = dividend % divisor; // Modulus operation
        end
    end
endmodule