module encoder_4_to_2 (
    input wire I0,
    input wire I1,
    input wire I2,
    input wire I3,
    output reg [1:0] Y
);

always @(*) begin
    case ({I3, I2, I1, I0})
        4'b0000: Y = 2'b00; // No active input
        4'b0001: Y = 2'b00; // I0 active
        4'b0010: Y = 2'b01; // I1 active
        4'b0011: Y = 2'b01; // I1 active (I0 can also be active)
        4'b0100: Y = 2'b10; // I2 active
        4'b0101: Y = 2'b10; // I2 active (I0 can also be active)
        4'b0110: Y = 2'b10; // I2 active (I1 can also be active)
        4'b0111: Y = 2'b10; // I2 active (I1 and I0 can also be active)
        4'b1000: Y = 2'b11; // I3 active
        4'b1001: Y = 2'b11; // I3 active (I0 can also be active)
        4'b1010: Y = 2'b11; // I3 active (I1 can also be active)
        4'b1011: Y = 2'b11; // I3 active (I1 and I0 can also be active)
        4'b1100: Y = 2'b11; // I3 active (I2 can also be active)
        4'b1101: Y = 2'b11; // I3 active (I2 and I0 can also be active)
        4'b1110: Y = 2'b11; // I3 active (I2 and I1 can also be active)
        4'b1111: Y = 2'b11; // I3 active (I2, I1 and I0 can also be active)
        default: Y = 2'b00; // Fallback case
    endcase
end

endmodule