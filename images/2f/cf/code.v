module dram_cell(
    input clk,
    input [15:0] data_in,
    input [3:0] addr,
    input read_enable,
    input write_enable,
    output reg [15:0] data_out
);
    reg [15:0] memory [0:15]; // 16 x 16-bit memory cells

    always @(posedge clk) begin
        if (write_enable) begin
            memory[addr] <= data_in; // Write data to memory
        end
        if (read_enable) begin
            data_out <= memory[addr]; // Read data from memory
        end
    end
endmodule