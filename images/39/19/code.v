module encoder_4to2 (
    input wire [3:0] I,
    output reg [1:0] Y
);
    always @(*) begin
        case (I)
            4'b0001: Y = 2'b00; // I0 is high
            4'b0010: Y = 2'b01; // I1 is high
            4'b0100: Y = 2'b10; // I2 is high
            4'b1000: Y = 2'b11; // I3 is high
            default: Y = 2'b00; // None are high or multiple are high
        endcase
    end
endmodule