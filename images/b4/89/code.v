module top_module
(
    input [3:0] binary_input,
    output reg [6:0] segments
);always @(*)
        case (binary_input)
            4'b0000: segments = 7'b1000000; // 0
            4'b0001: segments = 7'b1111001; // 1
            4'b0010: segments = 7'b0100100; // 2
            4'b0011: segments = 7'b0110000; // 3
            4'b0100: segments = 7'b0011001; // 4
            4'b0101: segments = 7'b0010010; // 5
            4'b0110: segments = 7'b0000010; // 6
            4'b0111: segments = 7'b1111000; // 7
            4'b1000: segments = 7'b0000000; // 8
            4'b1001: segments = 7'b0010000; // 9
            4'b1010: segments = 7'b0001000; // A
            4'b1011: segments = 7'b0000011; // B
            4'b1100: segments = 7'b1000110; // C
            4'b1101: segments = 7'b0100001; // D
            4'b1110: segments = 7'b0000110; // E
            4'b1111: segments = 7'b0001110; // F
            default: segments = 7'b1111111; // Off
        endcase
endmodule