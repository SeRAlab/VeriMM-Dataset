module SRAM_8bit (
    input [7:0] data_in,
    input [2:0] addr,
    input we,
    input clk,
    output reg [7:0] data_out
);
    reg [7:0] memory [0:7]; // 8x8 SRAM

    always @(posedge clk) begin
        if (we) begin
            memory[addr] <= data_in; // Write data to SRAM
        end
        data_out <= memory[addr]; // Always read data from SRAM
    end
endmodule