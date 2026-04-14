module qam_modulator (
    input [3:0] data,  // 4-bit input data
    output reg [3:0] I, // In-phase output
    output reg [3:0] Q  // Quadrature output
);

always @(data) begin
    case(data)
        4'b0000: begin I = 4'b0001; Q = 4'b0001; end // Symbol 1
        4'b0001: begin I = 4'b0001; Q = 4'b0011; end // Symbol 2
        4'b0010: begin I = 4'b0011; Q = 4'b0001; end // Symbol 3
        4'b0011: begin I = 4'b0011; Q = 4'b0011; end // Symbol 4
        4'b0100: begin I = 4'b0001; Q = 4'b0011; end // Symbol 5
        4'b0101: begin I = 4'b0001; Q = 4'b0011; end // Symbol 6
        4'b0110: begin I = 4'b0011; Q = 4'b0011; end // Symbol 7
        4'b0111: begin I = 4'b0011; Q = 4'b0001; end // Symbol 8
        4'b1000: begin I = 4'b0010; Q = 4'b0010; end // Symbol 9
        4'b1001: begin I = 4'b0010; Q = 4'b0000; end // Symbol 10
        4'b1010: begin I = 4'b0000; Q = 4'b0010; end // Symbol 11
        4'b1011: begin I = 4'b0000; Q = 4'b0000; end // Symbol 12
        4'b1100: begin I = 4'b0010; Q = 4'b0000; end // Symbol 13
        4'b1101: begin I = 4'b0010; Q = 4'b0010; end // Symbol 14
        4'b1110: begin I = 4'b0000; Q = 4'b0000; end // Symbol 15
        4'b1111: begin I = 4'b0000; Q = 4'b0010; end // Symbol 16
        default: begin I = 4'b0000; Q = 4'b0000; end
    endcase
end
endmodule