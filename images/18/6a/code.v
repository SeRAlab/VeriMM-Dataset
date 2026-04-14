module ofdm_bpsk_modulator(
    input wire clk,
    input wire reset,
    input wire enable,
    input wire [7:0] data_in, // 8 bits of data input
    output reg [1:0] data_out, // BPSK modulated output
    output reg valid // Valid signal for output
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            data_out <= 2'b00;
            valid <= 0;
        end else if (enable) begin
            case (data_in)
                8'b00000000: data_out <= 2'b00; // 0 -> +1
                8'b00000001: data_out <= 2'b01; // 1 -> -1
                default: data_out <= 2'b00; // Default case
            endcase
            valid <= 1;
        end else begin
            valid <= 0;
        end
    end
endmodule