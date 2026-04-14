module dram_cell (
    input clk,
    input we,
    input [3:0] addr,
    input [15:0] din,
    output reg [15:0] dout
);
    reg [15:0] memory [0:15]; // 16x16-bit memory

    always @(posedge clk) begin
        if (we) begin
            memory[addr] <= din; // Write data to memory
        end
        dout <= memory[addr]; // Read data from memory
    end
endmodule