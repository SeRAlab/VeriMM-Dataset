module dram_cell (
    input wire clk,
    input wire [7:0] data_in,
    input wire [7:0] addr,
    input wire write_enable,
    input wire read_enable,
    output reg [7:0] data_out
);
    reg [7:0] memory [0:255]; // 256 x 8-bit memory

    always @(posedge clk) begin
        if (write_enable) begin
            memory[addr] <= data_in; // Write data to memory
        end
    end

    always @(posedge clk) begin
        if (read_enable) begin
            data_out <= memory[addr]; // Read data from memory
        end
    end
endmodule