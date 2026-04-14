module divider_2bit (
    input [1:0] num, // 2-bit numerator
    input [1:0] den, // 2-bit denominator
    output reg [1:0] quot, // 2-bit quotient
    output reg [1:0] rem // 2-bit remainder
);
    
always @(*) begin
    if (den == 2'b00) begin
        quot = 2'b00; // Avoid division by zero
        rem = 2'b00;
    end else begin
        quot = num / den;
        rem = num % den;
    end
end

endmodule