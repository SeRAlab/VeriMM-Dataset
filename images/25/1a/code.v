module dram_cell (
    input wire clk,
    input wire [7:0] data_in,
    output reg [7:0] data_out,
    input wire read_en,
    input wire write_en,
    input wire [2:0] addr
);
    reg [7:0] memory [0:7]; // 8x8-bit memory

    always @(posedge clk) begin
        if (write_en) begin
            memory[addr] <= data_in; // Write data to memory
        end
        if (read_en) begin
            data_out <= memory[addr]; // Read data from memory
        end
    end
endmodule