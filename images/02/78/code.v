module ofdm_modulator (
    input clk,
    input reset,
    input [3:0] data_in,
    output reg [3:0] modulated_out
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        modulated_out <= 4'b0000;
    end else begin
        modulated_out <= data_in; // BPSK modulation
    end
end

endmodule