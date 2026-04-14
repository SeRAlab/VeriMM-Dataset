module SRAM_4bit (
    input wire [3:0] data_in,
    input wire write_enable,
    input wire [1:0] address,
    output reg [3:0] data_out
);
    reg [3:0] memory [0:3]; // 4 SRAM cells, each 4 bits wide

    always @(posedge write_enable) begin
        memory[address] <= data_in; // Write data to the selected address
    end

    always @(negedge write_enable) begin
        data_out <= memory[address]; // Read data from the selected address
    end
endmodule