module sram_16bit (
    input clk,
    input we,
    input [3:0] addr,
    input [15:0] d,
    output reg [15:0] q
);
    reg [15:0] memory [15:0]; // 16x16-bit memory

    always @(posedge clk) begin
        if (we) begin
            memory[addr] <= d; // Write data to memory
        end
        q <= memory[addr]; // Read data from memory
    end
endmodule