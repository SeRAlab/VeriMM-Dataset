module sram_16bit (
    input wire clk,
    input wire we,           // Write Enable
    input wire re,           // Read Enable
    input wire [3:0] addr,   // 4-bit address (16 x 16 bits = 256 bits)
    input wire [15:0] din,    // 16-bit data input
    output reg [15:0] dout    // 16-bit data output
);
    reg [15:0] memory [0:15]; // 16 x 16-bit memory

    always @(posedge clk) begin
        if (we) begin
            memory[addr] <= din; // Write data to memory
        end
        if (re) begin
            dout <= memory[addr]; // Read data from memory
        end
    end
endmodule