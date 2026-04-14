module sram_8bit (
    input wire [7:0] data_in,  // 8-bit data input
    input wire [2:0] address,   // 3-bit address input (for 8 locations)
    input wire write_enable,     // Write enable signal
    input wire read_enable,      // Read enable signal
    output reg [7:0] data_out    // 8-bit data output
);
    reg [7:0] memory [0:7];      // 8x8-bit memory array

    always @(posedge write_enable) begin
        memory[address] <= data_in; // Write data to specified address
    end

    always @(posedge read_enable) begin
        data_out <= memory[address]; // Read data from specified address
    end
endmodule