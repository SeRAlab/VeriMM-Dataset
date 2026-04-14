module sram_cell (
    input wire [15:0] address,
    input wire [15:0] data_in,
    output reg [15:0] data_out,
    input wire we, // write enable
    input wire re, // read enable
    input wire clk
);
    reg [15:0] memory [0:255]; // 256 x 16-bit memory

    always @(posedge clk) begin
        if (we) begin
            memory[address] <= data_in; // Write data to memory
        end
    end

    always @(posedge clk) begin
        if (re) begin
            data_out <= memory[address]; // Read data from memory
        end
    end
endmodule