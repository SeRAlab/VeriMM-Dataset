module divider_2bit (
    input [1:0] dividend,
    input [1:0] divisor,
    output reg [1:0] quotient,
    output reg remainder,
    output reg valid
);
    
    always @(*) begin
        if (divisor == 2'b00) begin
            quotient = 2'b00; // Undefined or can output a specific error code
            remainder = 1'b0; // Undefined
            valid = 1'b0; // Invalid operation
        end else begin
            quotient = dividend / divisor;
            remainder = dividend % divisor;
            valid = 1'b1; // Valid operation
        end
    end
endmodule