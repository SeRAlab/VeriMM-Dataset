module SRAM (
    input wire clk,
    input wire we,            // Write enable
    input wire re,            // Read enable
    input wire [2:0] address, // 3-bit address
    input wire [7:0] data_in, // 8-bit input data
    output reg [7:0] data_out // 8-bit output data
);
    reg [7:0] memory [0:7]; // 8 locations of 8-bit memory

    always @(posedge clk) begin
        if (we) begin
            memory[address] <= data_in; // Write data to memory
        end
        if (re) begin
            data_out <= memory[address]; // Read data from memory
        end
    end
endmodule