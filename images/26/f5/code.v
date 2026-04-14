module fixed_point_multiplier (
    input [3:0] A, // 4-bit fixed-point input A
    input [3:0] B, // 4-bit fixed-point input B
    output reg [3:0] result // 4-bit fixed-point output result
);
    always @(*) begin
        // Multiply the two fixed-point numbers and adjust for the 2 fractional bits.
        result = (A * B) >> 2; // Right shift by 2 to account for the 2 bits of fractional part
    end
endmodule