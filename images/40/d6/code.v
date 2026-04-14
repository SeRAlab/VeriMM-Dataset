module SRAM_Cell (
    input wire [3:0] data_in,
    input wire wr,
    input wire rd,
    input wire clk,
    output reg [3:0] data_out
);
    reg [3:0] memory;

    always @(posedge clk) begin
        if (wr) begin
            memory <= data_in; // Write data
        end
        if (rd) begin
            data_out <= memory; // Read data
        end
    end
endmodule