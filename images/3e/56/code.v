module OFDM_Modulator (
    input wire clk,
    input wire rst,
    input wire [7:0] bitstream,
    output reg [7:0] real_out,
    output reg [7:0] imag_out
);
    reg [1:0] qpsk_symbol;
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            real_out <= 8'b0;
            imag_out <= 8'b0;
        end else begin
            qpsk_symbol = bitstream[1:0];
            case (qpsk_symbol)
                2'b00: begin
                    real_out <= 8'hFF; // 1
                    imag_out <= 8'h00; // 0
                end
                2'b01: begin
                    real_out <= 8'h00; // 0
                    imag_out <= 8'hFF; // 1
                end
                2'b10: begin
                    real_out <= 8'h00; // 0
                    imag_out <= 8'h00; // -1
                end
                2'b11: begin
                    real_out <= 8'hFF; // -1
                    imag_out <= 8'hFF; // -1
                end
                default: begin
                    real_out <= 8'h00;
                    imag_out <= 8'h00;
                end
            endcase
        end
    end
endmodule