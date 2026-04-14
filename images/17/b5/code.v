module sram_cell (
    input wire [3:0] data_in,
    input wire we,
    input wire re,
    input wire clk,
    output reg [3:0] data_out
);
    reg [3:0] memory;

    always @(posedge clk) begin
        if (we) begin
            memory <= data_in; // Write data to memory
        end
        if (re) begin
            data_out <= memory; // Read data from memory
        end
    end
endmodule