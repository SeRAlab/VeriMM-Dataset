module qam_modulator (
    input [3:0] symbol,
    output reg [1:0] I,
    output reg [1:0] Q
);

always @(symbol) begin
    case (symbol)
        4'b0000: begin I = 2'b01; Q = 2'b01; end // (1, 1)
        4'b0001: begin I = 2'b01; Q = 2'b11; end // (1, 3)
        4'b0010: begin I = 2'b11; Q = 2'b01; end // (3, 1)
        4'b0011: begin I = 2'b11; Q = 2'b11; end // (3, 3)
        4'b0100: begin I = 2'b01; Q = 2'b00; end // (1, -1)
        4'b0101: begin I = 2'b01; Q = 2'b10; end // (1, -3)
        4'b0110: begin I = 2'b00; Q = 2'b01; end // (-1, 1)
        4'b0111: begin I = 2'b00; Q = 2'b11; end // (-1, 3)
        4'b1000: begin I = 2'b10; Q = 2'b01; end // (-3, 1)
        4'b1001: begin I = 2'b10; Q = 2'b11; end // (-3, 3)
        4'b1010: begin I = 2'b00; Q = 2'b00; end // (-1, -1)
        4'b1011: begin I = 2'b00; Q = 2'b10; end // (-1, -3)
        4'b1100: begin I = 2'b10; Q = 2'b00; end // (-3, -1)
        4'b1101: begin I = 2'b10; Q = 2'b10; end // (-3, -3)
        4'b1110: begin I = 2'b01; Q = 2'b00; end // (1, 0)
        4'b1111: begin I = 2'b00; Q = 2'b01; end // (0, 1)
        default: begin I = 2'b00; Q = 2'b00; end // Default case
    endcase
end
endmodule