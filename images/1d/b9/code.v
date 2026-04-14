module SRAM_16bit (
    input wire [15:0] data_in,
    input wire [3:0] address,
    input wire read_enable,
    input wire write_enable,
    output reg [15:0] data_out
);
    reg [15:0] memory [15:0]; // 16x16-bit memory array

    always @(posedge write_enable) begin
        memory[address] <= data_in; // Write data to memory
    end

    always @(posedge read_enable) begin
        data_out <= memory[address]; // Read data from memory
    end
endmodule