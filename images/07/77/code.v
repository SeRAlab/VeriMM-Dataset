module qam_demodulator (
    input wire clk,
    input wire rst,
    input wire [3:0] received_signal,
    output reg [1:0] I,
    output reg [1:0] Q
);

always @(posedge clk or posedge rst) begin
    if (rst) begin
        I <= 2'b00;
        Q <= 2'b00;
    end else begin
        case (received_signal)
            4'b0000: begin I <= 2'b00; Q <= 2'b00; end // Symbol 0
            4'b0001: begin I <= 2'b00; Q <= 2'b01; end // Symbol 1
            4'b0010: begin I <= 2'b00; Q <= 2'b10; end // Symbol 2
            4'b0011: begin I <= 2'b00; Q <= 2'b11; end // Symbol 3
            4'b0100: begin I <= 2'b01; Q <= 2'b00; end // Symbol 4
            4'b0101: begin I <= 2'b01; Q <= 2'b01; end // Symbol 5
            4'b0110: begin I <= 2'b01; Q <= 2'b10; end // Symbol 6
            4'b0111: begin I <= 2'b01; Q <= 2'b11; end // Symbol 7
            4'b1000: begin I <= 2'b10; Q <= 2'b00; end // Symbol 8
            4'b1001: begin I <= 2'b10; Q <= 2'b01; end // Symbol 9
            4'b1010: begin I <= 2'b10; Q <= 2'b10; end // Symbol A
            4'b1011: begin I <= 2'b10; Q <= 2'b11; end // Symbol B
            4'b1100: begin I <= 2'b11; Q <= 2'b00; end // Symbol C
            4'b1101: begin I <= 2'b11; Q <= 2'b01; end // Symbol D
            4'b1110: begin I <= 2'b11; Q <= 2'b10; end // Symbol E
            4'b1111: begin I <= 2'b11; Q <= 2'b11; end // Symbol F
            default: begin I <= 2'b00; Q <= 2'b00; end // Default case
        endcase
    end
end

endmodule