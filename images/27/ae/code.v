module dram_cell (
    input wire clk,
    input wire WRITE,
    input wire READ,
    input wire [15:0] data_in,
    output reg [15:0] data_out
);
    reg [15:0] memory;

    always @(posedge clk) begin
        if (WRITE) begin
            memory <= data_in; // Write data to memory
        end
        if (READ) begin
            data_out <= memory; // Read data from memory
        end
    end
endmodule