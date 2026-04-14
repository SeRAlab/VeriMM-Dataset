module dram_cell (
    input [15:0] data,
    input clk,
    input we,
    input [3:0] addr,
    output reg [15:0] q
);
    reg [15:0] memory [15:0]; // 16x16-bit memory array

    always @(posedge clk) begin
        if (we) begin
            memory[addr] <= data; // Write data to memory
        end
    end

    always @(posedge clk) begin
        if (!we) begin
            q <= memory[addr]; // Read data from memory
        end
    end
endmodule