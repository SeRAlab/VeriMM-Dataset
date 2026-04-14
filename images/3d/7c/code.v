module ofdm_symbol_generator(
    input clk,
    input rst,
    input [7:0] data_in,
    output reg [15:0] ofdm_symbol_out
);
    
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            ofdm_symbol_out <= 16'b0;
        end else begin
            ofdm_symbol_out <= {8'b0, data_in}; // Zero-pad the input symbol
        end
    end
endmodule