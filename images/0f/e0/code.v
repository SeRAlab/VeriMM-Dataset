module dram_cell (
    input wire clk,
    input wire [2:0] addr, // 3-bit address for 8 cells
    input wire we,         // Write enable
    input wire re,         // Read enable
    input wire data_in,    // Data input for writing
    output reg data_out     // Data output for reading
);
    reg [7:0] memory; // 8-bit memory to store data

    always @(posedge clk) begin
        if (we) begin
            memory[addr] <= data_in; // Write data to the specified address
        end
        if (re) begin
            data_out <= memory[addr]; // Read data from the specified address
        end
    end
endmodule