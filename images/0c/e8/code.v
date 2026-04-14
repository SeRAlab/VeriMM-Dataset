module encoder_4_to_2(
    input [3:0] I,   // 4 input lines
    output reg [1:0] O // 2 output lines
);
    always @(*) begin
        case (I)
            4'b0001: O = 2'b00; // I0 is high
            4'b0010: O = 2'b01; // I1 is high
            4'b0100: O = 2'b10; // I2 is high
            4'b1000: O = 2'b11; // I3 is high
            default: O = 2'b00; // All inputs low
        endcase
    end
endmodule