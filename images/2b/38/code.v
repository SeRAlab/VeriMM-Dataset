module ofdm_symbol_generator(
    input clk,
    input rst,
    input [3:0] data_in,
    output reg [7:0] ofdm_symbol
);
    always @(posedge clk or posedge rst) begin
        if (rst) begin
            ofdm_symbol <= 8'b0;
        end else begin
            ofdm_symbol <= {data_in, data_in}; // Simple mapping: repeat input
        end
    end
endmodule