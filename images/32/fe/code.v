module divider_2bit (
    input [1:0] dividend,
    input [1:0] divisor,
    output reg [1:0] quotient,
    output reg [1:0] remainder
);
    
    always @(*) begin
        if (divisor == 2'b00) begin
            quotient = 2'b00;   // Division by zero, output zero
            remainder = 2'b00;  // Remainder is also zero
        end else begin
            quotient = dividend / divisor; // Perform division
            remainder = dividend % divisor; // Calculate remainder
        end
    end
endmodule