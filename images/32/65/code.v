module sram_cell (
    input wire [15:0] data_in,
    input wire [3:0] addr,
    input wire read_enable,
    input wire write_enable,
    output reg [15:0] data_out
);
    reg [15:0] memory [0:15]; // 16 x 16-bit memory

    always @(posedge write_enable) begin
        memory[addr] <= data_in; // Write data to memory
    end

    always @(posedge read_enable) begin
        data_out <= memory[addr]; // Read data from memory
    end
endmodule