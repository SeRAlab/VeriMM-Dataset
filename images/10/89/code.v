module ofdm_modulator (
    input wire clk,
    input wire rst,
    input wire [3:0] symbol_in,
    output reg [15:0] modulated_out
);
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            modulated_out <= 16'b0;
        end else begin
            modulated_out <= {12'b0, symbol_in}; // Place symbol_in in the lower 4 bits
        end
    end
endmodule