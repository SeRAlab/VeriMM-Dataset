module dram_cell (
    input clk,
    input wen,
    input ren,
    input [15:0] data_in,
    output reg [15:0] data_out
);
    reg [15:0] memory;

    always @(posedge clk) begin
        if (wen) begin
            memory <= data_in; // Write data to memory
        end
        if (ren) begin
            data_out <= memory; // Read data from memory
        end
    end
endmodule