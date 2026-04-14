module SRT_Divider (
    input [7:0] dividend,
    input [7:0] divisor,
    output reg [7:0] quotient,
    output reg [7:0] remainder
);
    integer i;

    always @(*) begin
        quotient = 0;
        remainder = dividend;
        
        for (i = 7; i >= 0; i = i - 1) begin
            remainder = remainder << 1; // Shift left to make room for the next bit
            remainder[0] = dividend[i]; // Bring in next bit of dividend
            
            if (remainder >= divisor) begin
                remainder = remainder - divisor; // Subtract divisor from remainder
                quotient[i] = 1; // Set the quotient bit
            end else begin
                quotient[i] = 0; // Clear the quotient bit
            end
        end
    end
endmodule