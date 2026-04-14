module encoder_4to2 (
    input [3:0] in,
    output reg [1:0] out
);
    always @(*) begin
        case (in)
            4'b0000: out = 2'b00; // All inputs low
            4'b0001: out = 2'b00; // D is high
            4'b0010: out = 2'b01; // C is high
            4'b0011: out = 2'b01; // C is high
            4'b0100: out = 2'b10; // B is high
            4'b0101: out = 2'b10; // B is high
            4'b0110: out = 2'b10; // B is high
            4'b0111: out = 2'b10; // B is high
            4'b1000: out = 2'b11; // A is high
            4'b1001: out = 2'b11; // A is high
            4'b1010: out = 2'b11; // A is high
            4'b1011: out = 2'b11; // A is high
            4'b1100: out = 2'b11; // A is high
            4'b1101: out = 2'b11; // A is high
            4'b1110: out = 2'b11; // A is high
            4'b1111: out = 2'b11; // A is high
            default: out = 2'b00; // Default case
        endcase
    end
endmodule