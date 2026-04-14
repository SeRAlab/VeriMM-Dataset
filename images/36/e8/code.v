module fixed_point_multiplier (
    input [7:0] A, // 8-bit fixed-point input A
    input [7:0] B, // 8-bit fixed-point input B
    output reg [15:0] P // 16-bit fixed-point output P
);
    always @(*) begin
        // Multiply the two fixed-point numbers and adjust the result
        P = A * B; // The multiplication is performed directly
    end
endmodule