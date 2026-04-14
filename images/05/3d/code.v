module dram_cell (
    input wire clk,
    input wire wr_en,
    input wire rd_en,
    input wire [15:0] data_in,
    output reg [15:0] data_out
);
    reg [15:0] memory;

    always @(posedge clk) begin
        if (wr_en) begin
            memory <= data_in;  // Write data to memory
        end
    end

    always @(posedge clk) begin
        if (rd_en) begin
            data_out <= memory;  // Read data from memory
        end
    end
endmodule