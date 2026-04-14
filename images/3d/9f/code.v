module dram_cell (
    input clk,
    input write_enable,
    input [1:0] address,
    input [3:0] data_in,
    output reg [3:0] data_out
);
    reg [3:0] memory; // 4-bit memory cell

    always @(posedge clk) begin
        if (write_enable) begin
            memory <= data_in; // Write operation
        end
        data_out <= memory; // Always output the stored data
    end
endmodule