module SRAM_4bit (
    input wire [3:0] data_in,
    input wire write_enable,
    input wire read_enable,
    input wire [1:0] address,
    output reg [3:0] data_out
);
    reg [3:0] memory [3:0]; // 4 locations of 4-bit memory

    always @(posedge write_enable) begin
        memory[address] <= data_in; // Write data to memory
    end

    always @(posedge read_enable) begin
        data_out <= memory[address]; // Read data from memory
    end
endmodule