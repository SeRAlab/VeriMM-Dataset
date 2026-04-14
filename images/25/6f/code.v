module dram_cell (
    input clk,
    input we,            // write enable
    input [3:0] data_in, // 4-bit data input
    output reg [3:0] data_out // 4-bit data output
);
    reg [3:0] memory;    // 4-bit storage

    always @(posedge clk) begin
        if (we) begin
            memory <= data_in; // Write data to memory on write enable
        end
        data_out <= memory; // Output the stored data
    end
endmodule