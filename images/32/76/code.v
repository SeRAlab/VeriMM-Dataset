module SRAM_4bit(
    input wire clk,
    input wire write_enable,
    input wire read_enable,
    input wire [3:0] data_in,
    output reg [3:0] data_out
);
    reg [3:0] memory;

    always @(posedge clk) begin
        if (write_enable) begin
            memory <= data_in; // Write data to memory
        end
        if (read_enable) begin
            data_out <= memory; // Read data from memory
        end
    end
endmodule