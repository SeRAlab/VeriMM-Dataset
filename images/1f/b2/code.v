module SRAM_Cell (
    input wire [3:0] data_in,
    input wire [1:0] address,
    input wire read_enable,
    input wire write_enable,
    output reg [3:0] data_out
);
    reg [3:0] memory [0:3]; // 4-bit SRAM cell with 4 locations

    always @(posedge write_enable) begin
        memory[address] <= data_in; // Write data into memory
    end

    always @(posedge read_enable) begin
        data_out <= memory[address]; // Read data from memory
    end
endmodule