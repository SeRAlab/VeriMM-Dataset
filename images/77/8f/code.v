module top_module(
    input [3:0] binary,
    output reg [6:0] segment);always @(*) begin
        case (binary)
            4'b0000: segment = 7'b0111111; // 0
            4'b0001: segment = 7'b0000110; // 1
            4'b0010: segment = 7'b1011011; // 2
            4'b0011: segment = 7'b1001111; // 3
            4'b0100: segment = 7'b1100110; // 4
            4'b0101: segment = 7'b1101101; // 5
            4'b0110: segment = 7'b1111101; // 6
            4'b0111: segment = 7'b0000111; // 7
            4'b1000: segment = 7'b1111111; // 8
            4'b1001: segment = 7'b1101111; // 9
            default: segment = 7'b0000000; // blank
        endcase
    end

endmodule