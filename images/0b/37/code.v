module dram_cell (
    input clk,
    input read_en,
    input write_en,
    input [7:0] data_in,
    input [2:0] addr,
    output reg [7:0] data_out
);
    reg [7:0] memory [0:7]; // 8-bit DRAM cell with 8 addresses

    always @(posedge clk) begin
        if (write_en) begin
            memory[addr] <= data_in; // Write data to memory
        end
        if (read_en) begin
            data_out <= memory[addr]; // Read data from memory
        end
    end
endmodule