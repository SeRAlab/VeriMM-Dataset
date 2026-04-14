module dram_cell (
    input clk,
    input wr_en,
    input rd_en,
    input [15:0] data_in,
    output reg [15:0] data_out
);
    reg [15:0] memory;

    always @(posedge clk) begin
        if (wr_en) begin
            memory <= data_in;
        end
        if (rd_en) begin
            data_out <= memory;
        end
    end
endmodule