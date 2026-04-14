module ofdm_modulator (
    input wire clk,
    input wire rst,
    input wire [3:0] data_in,
    input wire data_valid,
    output reg [3:0] symbol_out,
    output reg symbol_valid
);

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            symbol_out <= 4'b0000;
            symbol_valid <= 1'b0;
        end else if (data_valid) begin
            symbol_out <= data_in; // Simple direct mapping
            symbol_valid <= 1'b1;   // Indicate valid output
        end else begin
            symbol_valid <= 1'b0;   // No valid output if data_valid is low
        end
    end

endmodule