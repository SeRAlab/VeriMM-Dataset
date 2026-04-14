module SRAM_4bit (
    input [1:0] address,
    input [3:0] data_in,
    input write_enable,
    input clock,
    output reg [3:0] data_out
);
    reg [3:0] memory [3:0]; // 4-bit memory with 4 locations

    always @(posedge clock) begin
        if (write_enable) begin
            memory[address] <= data_in; // Write data to the selected address
        end
        data_out <= memory[address]; // Read data from the selected address
    end
endmodule