module top_module(
    input [3:0] hex_in,
    input dp,
    output reg [6:0] sseg
);always @(*)
begin
    case (hex_in)
        4'b0000: sseg = 7'b1111110; // 0
        4'b0001: sseg = 7'b0110000; // 1
        4'b0010: sseg = 7'b1101101; // 2
        4'b0011: sseg = 7'b1111001; // 3
        4'b0100: sseg = 7'b0110011; // 4
        4'b0101: sseg = 7'b1011011; // 5
        4'b0110: sseg = 7'b1011111; // 6
        4'b0111: sseg = 7'b1110000; // 7
        4'b1000: sseg = 7'b1111111; // 8
        4'b1001: sseg = 7'b1111011; // 9
        4'b1010: sseg = 7'b1110111; // A
        4'b1011: sseg = 7'b0011111; // B
        4'b1100: sseg = 7'b1001110; // C
        4'b1101: sseg = 7'b0111101; // D
        4'b1110: sseg = 7'b1001111; // E
        4'b1111: sseg = 7'b1000111; // F
        default: sseg = 7'b0000000; // Invalid input
    endcase
    
    if (dp)
        sseg[6] = 1;
end

endmodule