module dram_cell (
    input wire clk,
    input wire write_enable,
    input wire [2:0] address,
    input wire [7:0] data_in,
    output reg [7:0] data_out
);
    reg [7:0] memory [7:0]; // 8x8-bit memory

    always @(posedge clk) begin
        if (write_enable) begin
            memory[address] <= data_in; // Write data
        end
        data_out <= memory[address]; // Read data
    end
endmodule