module sram_cell (
    input wire clk,
    input wire [3:0] address,
    input wire [15:0] data_in,
    input wire we, // write enable
    input wire re, // read enable
    output reg [15:0] data_out
);
    reg [15:0] memory [0:15]; // 16x16 bits SRAM

    always @(posedge clk) begin
        if (we) begin
            memory[address] <= data_in; // Write data
        end
        if (re) begin
            data_out <= memory[address]; // Read data
        end
    end
endmodule