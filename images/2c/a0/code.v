module qam_modulator (
    input [3:0] data_in,
    output reg [1:0] I_out,
    output reg [1:0] Q_out
);

always @(*) begin
    case (data_in)
        4'b0000: begin I_out = 2'b00; Q_out = 2'b00; end // 0
        4'b0001: begin I_out = 2'b00; Q_out = 2'b01; end // 1
        4'b0010: begin I_out = 2'b01; Q_out = 2'b00; end // 2
        4'b0011: begin I_out = 2'b01; Q_out = 2'b01; end // 3
        4'b0100: begin I_out = 2'b00; Q_out = 2'b10; end // 4
        4'b0101: begin I_out = 2'b00; Q_out = 2'b11; end // 5
        4'b0110: begin I_out = 2'b01; Q_out = 2'b10; end // 6
        4'b0111: begin I_out = 2'b01; Q_out = 2'b11; end // 7
        4'b1000: begin I_out = 2'b10; Q_out = 2'b00; end // 8
        4'b1001: begin I_out = 2'b10; Q_out = 2'b01; end // 9
        4'b1010: begin I_out = 2'b11; Q_out = 2'b00; end // 10
        4'b1011: begin I_out = 2'b11; Q_out = 2'b01; end // 11
        4'b1100: begin I_out = 2'b10; Q_out = 2'b10; end // 12
        4'b1101: begin I_out = 2'b10; Q_out = 2'b11; end // 13
        4'b1110: begin I_out = 2'b11; Q_out = 2'b10; end // 14
        4'b1111: begin I_out = 2'b11; Q_out = 2'b11; end // 15
        default: begin I_out = 2'bxx; Q_out = 2'bxx; end // undefined
    endcase
end

endmodule