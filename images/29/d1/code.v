module sram_cell (
    input wire [7:0] data_in,
    output reg [7:0] data_out,
    input wire we, // write enable
    input wire re, // read enable
    input wire [2:0] addr, // address input
    input wire clk // clock signal
);
    reg [7:0] memory [0:7]; // 8 x 8-bit memory

    always @(posedge clk) begin
        if (we) begin
            memory[addr] <= data_in; // Write data to memory
        end
    end

    always @(posedge clk) begin
        if (re) begin
            data_out <= memory[addr]; // Read data from memory
        end
    end
endmodule