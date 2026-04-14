module sram_cell (
    input wire [7:0] data_in,
    input wire read_enable,
    input wire write_enable,
    input wire [2:0] address,
    output reg [7:0] data_out
);

    reg [7:0] memory [7:0]; // 8 locations of 8-bit memory

    always @(posedge write_enable) begin
        if (write_enable) begin
            memory[address] <= data_in; // Write data to the addressed location
        end
    end

    always @(posedge read_enable) begin
        if (read_enable) begin
            data_out <= memory[address]; // Read data from the addressed location
        end
    end
endmodule