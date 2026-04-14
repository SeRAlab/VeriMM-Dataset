module SRAM_16bit (
    input [3:0] address,
    input [15:0] data_in,
    input we,
    input clk,
    output reg [15:0] data_out
);
    reg [15:0] memory [0:15]; // 16 locations of 16-bit memory

    always @(posedge clk) begin
        if (we) begin
            memory[address] <= data_in; // Write operation
        end else begin
            data_out <= memory[address]; // Read operation
        end
    end
endmodule