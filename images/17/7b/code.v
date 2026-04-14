module dram_cell (
    input clk,
    input [7:0] data_in,
    input read,
    input write,
    output reg [7:0] data_out
);
    reg [7:0] memory;

    always @(posedge clk) begin
        if (write) begin
            memory <= data_in; // Write data to memory on write signal
        end
        if (read) begin
            data_out <= memory; // Read data from memory on read signal
        end
    end
endmodule