module SRAM_4bit (
    input [3:0] data_in,
    input [1:0] addr,
    input write_enable,
    input clk,
    output reg [3:0] data_out
);
    reg [3:0] memory [3:0]; // 4x4 memory array

    always @(posedge clk) begin
        if (write_enable) begin
            memory[addr] <= data_in; // Write data to memory
        end
        data_out <= memory[addr]; // Read data from memory
    end
endmodule