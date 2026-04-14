module SRAM_Cell (
    input wire [3:0] address,  // 4-bit address for 16 cells
    input wire [15:0] data_in,  // 16-bit data input
    input wire read_enable,  // Control signal for reading
    input wire write_enable, // Control signal for writing
    output reg [15:0] data_out // 16-bit data output
);
    reg [15:0] memory [0:15]; // Array to represent 16 memory cells

    always @(posedge write_enable) begin
        memory[address] <= data_in; // Write data to the specified address
    end

    always @(posedge read_enable) begin
        data_out <= memory[address]; // Read data from the specified address
    end
endmodule