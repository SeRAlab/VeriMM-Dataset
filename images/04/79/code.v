module ofdm_modulator(
    input [3:0] symbol_in,
    output reg [3:0] symbol_out,
    input clk,
    input reset
);
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            symbol_out <= 4'b0000;
        end else begin
            symbol_out <= (symbol_in * 3) > 15 ? 4'b1111 : (symbol_in * 3);
        end
    end
endmodule