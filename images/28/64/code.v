module SRAM_Cell (
    input wire clk,
    input wire write_enable,
    input wire [2:0] address,
    input wire [7:0] data_in,
    output reg [7:0] data_out
);
    reg [7:0] memory [0:7]; // 8-bit SRAM with 8 locations

    always @(posedge clk) begin
        if (write_enable) begin
            memory[address] <= data_in;
        end
        data_out <= memory[address];
    end
endmodule