module ofdm_mapper (
    input wire [3:0] data_in,
    output reg [15:0] ofdm_out
);
    always @(data_in) begin
        case (data_in)
            4'b0000: ofdm_out = 16'h0001;
            4'b0001: ofdm_out = 16'h0010;
            4'b0010: ofdm_out = 16'h0100;
            4'b0011: ofdm_out = 16'h1000;
            4'b0100: ofdm_out = 16'h0002;
            4'b0101: ofdm_out = 16'h0020;
            4'b0110: ofdm_out = 16'h0200;
            4'b0111: ofdm_out = 16'h2000;
            4'b1000: ofdm_out = 16'h0004;
            4'b1001: ofdm_out = 16'h0040;
            4'b1010: ofdm_out = 16'h0400;
            4'b1011: ofdm_out = 16'h4000;
            4'b1100: ofdm_out = 16'h0008;
            4'b1101: ofdm_out = 16'h0080;
            4'b1110: ofdm_out = 16'h0800;
            4'b1111: ofdm_out = 16'h8000;
            default: ofdm_out = 16'h0000; // Default case
        endcase
    end
endmodule