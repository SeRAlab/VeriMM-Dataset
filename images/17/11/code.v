module sram_cell (
    input wire [7:0] data_in,
    input wire [2:0] address,
    input wire read_enable,
    input wire write_enable,
    output reg [7:0] data_out
);
    reg [7:0] memory [7:0]; // 8x8 SRAM storage

    always @(posedge write_enable) begin
        memory[address] <= data_in; // Write data to memory
    end

    always @(posedge read_enable) begin
        data_out <= memory[address]; // Read data from memory
    end
endmodule