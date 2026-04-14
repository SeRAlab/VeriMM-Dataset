module ofdm_mapper (
    input [3:0] bin_in,
    output reg [1:0] real_out,
    output reg [1:0] imag_out
);
    always @(bin_in) begin
        case (bin_in)
            4'b0000: begin real_out = 2'b00; imag_out = 2'b00; end // -3 - 3j
            4'b0001: begin real_out = 2'b00; imag_out = 2'b01; end // -3 - 1j
            4'b0010: begin real_out = 2'b00; imag_out = 2'b10; end // -3 + 1j
            4'b0011: begin real_out = 2'b00; imag_out = 2'b11; end // -3 + 3j
            4'b0100: begin real_out = 2'b01; imag_out = 2'b00; end // -1 - 3j
            4'b0101: begin real_out = 2'b01; imag_out = 2'b01; end // -1 - 1j
            4'b0110: begin real_out = 2'b01; imag_out = 2'b10; end // -1 + 1j
            4'b0111: begin real_out = 2'b01; imag_out = 2'b11; end // -1 + 3j
            4'b1000: begin real_out = 2'b10; imag_out = 2'b00; end // +1 - 3j
            4'b1001: begin real_out = 2'b10; imag_out = 2'b01; end // +1 - 1j
            4'b1010: begin real_out = 2'b10; imag_out = 2'b10; end // +1 + 1j
            4'b1011: begin real_out = 2'b10; imag_out = 2'b11; end // +1 + 3j
            4'b1100: begin real_out = 2'b11; imag_out = 2'b00; end // +3 - 3j
            4'b1101: begin real_out = 2'b11; imag_out = 2'b01; end // +3 - 1j
            4'b1110: begin real_out = 2'b11; imag_out = 2'b10; end // +3 + 1j
            4'b1111: begin real_out = 2'b11; imag_out = 2'b11; end // +3 + 3j
            default: begin real_out = 2'b00; imag_out = 2'b00; end
        endcase
    end
endmodule