module SRT_Divider (
    input [3:0] numerator,
    input [3:0] denominator,
    output reg [3:0] quotient,
    output reg [3:0] remainder
);
    integer i;
    reg [4:0] temp_numerator;
    reg [4:0] temp_denominator;
    
    always @* begin
        quotient = 0;
        remainder = numerator;
        temp_denominator = {1'b0, denominator}; // Extend by 1 bit for comparison
        
        for (i = 3; i >= 0; i = i - 1) begin
            temp_numerator = {remainder[3], remainder}; // Shift left the remainder
            remainder = temp_numerator - temp_denominator; // Subtract denominator
            if (remainder[4]) begin // If remainder is negative
                remainder = temp_numerator; // Restore remainder
            end else begin
                quotient[i] = 1; // Set quotient bit
            end
        end
    end
endmodule