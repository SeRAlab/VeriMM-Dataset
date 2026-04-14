module dram_cell (
    input [15:0] data,
    input clk,
    input we,
    input re,
    output reg [15:0] q
);
    reg [15:0] memory;

    always @(posedge clk) begin
        if (we) begin
            memory <= data; // Write data to memory on write enable
        end
    end

    always @(posedge clk) begin
        if (re) begin
            q <= memory; // Read data from memory on read enable
        end
    end
endmodule