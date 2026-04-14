module qam_modulator(
    input [3:0] data_in,
    output reg [3:0] I_out,
    output reg [3:0] Q_out
);
    always @(data_in) begin
        case (data_in)
            4'b0000: begin I_out = 4'b0000; Q_out = 4'b0000; end
            4'b0001: begin I_out = 4'b0000; Q_out = 4'b0001; end
            4'b0010: begin I_out = 4'b0000; Q_out = 4'b1111; end // -1 in binary for 4 bits
            4'b0011: begin I_out = 4'b0001; Q_out = 4'b0000; end
            4'b0100: begin I_out = 4'b0001; Q_out = 4'b0001; end
            4'b0101: begin I_out = 4'b0001; Q_out = 4'b1111; end // -1 in binary for 4 bits
            4'b0110: begin I_out = 4'b1111; Q_out = 4'b0000; end // -1 in binary
            4'b0111: begin I_out = 4'b1111; Q_out = 4'b0001; end
            4'b1000: begin I_out = 4'b1111; Q_out = 4'b1111; end // -1 in binary
            4'b1001: begin I_out = 4'b0000; Q_out = 4'b0010; end // 2 in binary
            4'b1010: begin I_out = 4'b0000; Q_out = 4'b1101; end // -2 in binary for 4 bits
            4'b1011: begin I_out = 4'b0010; Q_out = 4'b0000; end // 2 in binary
            4'b1100: begin I_out = 4'b0010; Q_out = 4'b0001; end
            4'b1101: begin I_out = 4'b0010; Q_out = 4'b1111; end // -1 in binary
            4'b1110: begin I_out = 4'b1101; Q_out = 4'b0000; end // -2 in binary
            4'b1111: begin I_out = 4'b1101; Q_out = 4'b0001; end
            default: begin I_out = 4'b0000; Q_out = 4'b0000; end
        endcase
    end
endmodule