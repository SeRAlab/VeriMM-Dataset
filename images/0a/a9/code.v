module dram_cell (
    input wire clk,
    input wire write_enable,
    input wire [2:0] address, // 3 bits for 8 addresses
    input wire [7:0] data_in,
    output reg [7:0] data_out
);
    reg [7:0] memory [0:7]; // 8-bit DRAM with 8 addresses

    always @(posedge clk) begin
        if (write_enable) begin
            memory[address] <= data_in; // Write data to memory
        end
        data_out <= memory[address]; // Read data from memory
    end
endmodule