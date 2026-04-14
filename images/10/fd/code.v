module sram_cell (
    input wire write_enable,
    input wire [1:0] address,
    input wire [3:0] data_in,
    output reg [3:0] data_out
);
    reg [3:0] memory [0:3]; // 4-bit memory with 4 locations

    always @(posedge write_enable) begin
        memory[address] <= data_in; // Write data to memory
    end

    always @(negedge write_enable) begin
        data_out <= memory[address]; // Read data from memory
    end
endmodule