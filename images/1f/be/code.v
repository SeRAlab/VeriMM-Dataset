module sram_cell (
    input wire clk,
    input wire we,        // Write enable
    input wire re,        // Read enable
    input wire [3:0] addr, // Address for the SRAM cell
    input wire [15:0] data_in, // Data input for writing
    output reg [15:0] data_out // Data output for reading
);
    reg [15:0] memory [0:15]; // 16x16-bit memory array

    always @(posedge clk) begin
        if (we) begin
            memory[addr] <= data_in; // Write data to memory
        end
        if (re) begin
            data_out <= memory[addr]; // Read data from memory
        end
    end
endmodule