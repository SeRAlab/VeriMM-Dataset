module SRAM_16bit (
    input wire clk,
    input wire enable,
    input wire write,
    input wire read,
    input wire [15:0] data_in,
    output reg [15:0] data_out
);
    reg [15:0] memory;

    always @(posedge clk) begin
        if (enable) begin
            if (write) begin
                memory <= data_in; // Write data to memory
            end
            if (read) begin
                data_out <= memory; // Read data from memory
            end
        end
    end
endmodule