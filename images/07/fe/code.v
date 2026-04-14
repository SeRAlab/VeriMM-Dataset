module SRAM_Cell (
    input wire [7:0] data_in,
    input wire write_enable,
    input wire [2:0] address,
    output reg [7:0] data_out
);
    reg [7:0] memory [7:0]; // 8x8 SRAM memory

    always @(posedge write_enable) begin
        memory[address] <= data_in; // Store data in memory
    end

    always @(negedge write_enable) begin
        data_out <= memory[address]; // Output data from memory
    end
endmodule