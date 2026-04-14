module encoder_4to2 (
    input wire I0,
    input wire I1,
    input wire I2,
    input wire I3,
    output reg [1:0] Y
);
    always @(*) begin
        case ({I3, I2, I1, I0})
            4'b0000: Y = 2'b00; // Invalid state
            4'b0001: Y = 2'b00; // I0 active
            4'b0010: Y = 2'b01; // I1 active
            4'b0100: Y = 2'b10; // I2 active
            4'b1000: Y = 2'b11; // I3 active
            default: Y = 2'b00; // Invalid state for multiple high inputs
        endcase
    end
endmodule