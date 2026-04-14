module SRT_Divider(
    input [15:0] dividend,
    input [15:0] divisor,
    output reg [15:0] quotient,
    output reg [15:0] remainder
);
    // Internal signals
    reg [31:0] temp_dividend;
    reg [15:0] temp_quotient;
    
    always @(*) begin
        // Initialize
        temp_dividend = dividend;
        temp_quotient = 0;
        
        // SRT division algorithm implementation
        if (divisor != 0) begin // Check for division by zero
            // Perform division
            temp_quotient = temp_dividend / divisor;
            remainder = temp_dividend % divisor;
        end else begin
            // Handle division by zero
            temp_quotient = 16'hFFFF; // Indicate error
            remainder = dividend; // Remainder is dividend
        end
        
        quotient = temp_quotient;
    end
endmodule