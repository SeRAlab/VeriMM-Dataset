module sram_cell (
    input wire [7:0] data_in,
    input wire write_en,
    input wire read_en,
    input wire [2:0] address,
    output reg [7:0] data_out
);
    reg [7:0] memory [0:7]; // 8-bit memory with 8 addresses

    always @(posedge write_en) begin
        if (write_en)
            memory[address] <= data_in; // Write data to memory on write enable
    end

    always @(posedge read_en) begin
        if (read_en)
            data_out <= memory[address]; // Read data from memory on read enable
    end
endmodule