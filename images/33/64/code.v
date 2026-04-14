module dram_cell (
    input [3:0] data_in,
    input we,
    input clk,
    output reg [3:0] data_out
);
    reg [3:0] memory;

    always @(posedge clk) begin
        if (we) begin
            memory <= data_in; // Write data to memory
        end
        data_out <= memory; // Read data from memory
    end
endmodule