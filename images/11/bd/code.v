module DRAM_Cell (
    input wire clk,
    input wire [3:0] data_in,
    input wire write_enable,
    input wire [1:0] address,
    output reg [3:0] data_out
);
    reg [3:0] memory [0:3]; // 4x4-bit memory

    always @(posedge clk) begin
        if (write_enable) begin
            memory[address] <= data_in; // Write data to specified address
        end
        data_out <= memory[address]; // Read data from specified address
    end
endmodule