module dram_cell (
    input [7:0] data_in,
    input [2:0] addr,
    input we,
    input clk,
    output reg [7:0] data_out
);
    reg [7:0] memory [0:7]; // 8-bit DRAM with 8 addresses

    always @(posedge clk) begin
        if (we) begin
            memory[addr] <= data_in; // Write data to memory
        end else begin
            data_out <= memory[addr]; // Read data from memory
        end
    end
endmodule