module dram_cell (
    input wire clk,
    input wire wr,
    input wire rd,
    input wire [3:0] addr,
    input wire [15:0] data_in,
    output reg [15:0] data_out
);
    reg [15:0] memory [0:15]; // 16 cells of 16 bits each

    always @(posedge clk) begin
        if (wr) begin
            memory[addr] <= data_in; // Write data to the memory
        end
        if (rd) begin
            data_out <= memory[addr]; // Read data from the memory
        end
    end
endmodule