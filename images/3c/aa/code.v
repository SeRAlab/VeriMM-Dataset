module bluetooth_strength (
    input [4:0] strength_in,
    output reg [1:0] strength_out
);

always @(*) begin
    if (strength_in < 5)
        strength_out = 2'b00; // Less than 5
    else if (strength_in <= 10)
        strength_out = 2'b01; // Between 5 and 10
    else if (strength_in <= 15)
        strength_out = 2'b10; // Between 11 and 15
    else
        strength_out = 2'b11; // Greater than 15
end

endmodule