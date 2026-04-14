module dram_cell (
    input clk,
    input wr_en,
    input [3:0] addr,
    input [15:0] data_in,
    output reg [15:0] data_out
);
    reg [15:0] memory [0:15]; // 16 x 16-bit memory cells

    always @(posedge clk) begin
        if (wr_en) begin
            memory[addr] <= data_in; // Write data to memory
        end
        else begin
            data_out <= memory[addr]; // Read data from memory
        end
    end
endmodule