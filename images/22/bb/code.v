module sram_cell (
    input wire clk,
    input wire we,          // Write Enable
    input wire [1:0] addr, // 2-bit Address (can address 4 bits)
    input wire [3:0] din,  // 4-bit Data Input
    input wire re,         // Read Enable
    output reg [3:0] dout  // 4-bit Data Output
);
    reg [3:0] memory [0:3]; // 4-bit SRAM with 4 cells

    always @(posedge clk) begin
        if (we) begin
            memory[addr] <= din; // Write data to the specified address
        end
        if (re) begin
            dout <= memory[addr]; // Read data from the specified address
        end
    end
endmodule