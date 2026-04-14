module qam16_modulator (
    input wire [3:0] data_in,
    output reg [1:0] I,
    output reg [1:0] Q
);
    always @(*) begin
        case (data_in)
            4'b0000: begin I = 2'b00; Q = 2'b00; end // 00
            4'b0001: begin I = 2'b00; Q = 2'b01; end // 01
            4'b0010: begin I = 2'b00; Q = 2'b10; end // 02
            4'b0011: begin I = 2'b00; Q = 2'b11; end // 03
            4'b0100: begin I = 2'b01; Q = 2'b00; end // 04
            4'b0101: begin I = 2'b01; Q = 2'b01; end // 05
            4'b0110: begin I = 2'b01; Q = 2'b10; end // 06
            4'b0111: begin I = 2'b01; Q = 2'b11; end // 07
            4'b1000: begin I = 2'b10; Q = 2'b00; end // 08
            4'b1001: begin I = 2'b10; Q = 2'b01; end // 09
            4'b1010: begin I = 2'b10; Q = 2'b10; end // 10
            4'b1011: begin I = 2'b10; Q = 2'b11; end // 11
            4'b1100: begin I = 2'b11; Q = 2'b00; end // 12
            4'b1101: begin I = 2'b11; Q = 2'b01; end // 13
            4'b1110: begin I = 2'b11; Q = 2'b10; end // 14
            4'b1111: begin I = 2'b11; Q = 2'b11; end // 15
            default: begin I = 2'b00; Q = 2'b00; end
        endcase
    end
endmodule