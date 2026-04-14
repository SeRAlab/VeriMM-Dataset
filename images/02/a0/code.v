module divider_2bit (
    input [1:0] A, // Dividend
    input [1:0] B, // Divisor
    output reg [1:0] Quotient, // Quotient
    output reg [1:0] Remainder // Remainder
);
    
always @(*) begin
    if (B == 2'b00) begin
        Quotient = 2'b00;
        Remainder = 2'b00;
    end else begin
        Quotient = A / B;
        Remainder = A % B;
    end
end

endmodule