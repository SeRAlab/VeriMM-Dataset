module dram_cell (
    input wire [7:0] data_in,
    input wire wr_enable,
    input wire rd_enable,
    input wire clk,
    output reg [7:0] data_out
);

    reg [7:0] memory;

    always @(posedge clk) begin
        if (wr_enable) begin
            memory <= data_in;  // Write data to memory
        end
        if (rd_enable) begin
            data_out <= memory;  // Read data from memory
        end
    end
endmodule