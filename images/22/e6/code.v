module SRAM_16bit (
    input clk,
    input wr_en,
    input [3:0] addr,
    input [15:0] data_in,
    output reg [15:0] data_out
);
    reg [15:0] memory [15:0]; // 16x16-bit memory

    always @(posedge clk) begin
        if (wr_en) begin
            memory[addr] <= data_in;  // Write operation
        end
        data_out <= memory[addr]; // Read operation
    end
endmodule