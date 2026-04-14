module SRAM_16bit (
    input wire clk,
    input wire enable,
    input wire write,
    input wire [3:0] address,
    input wire [15:0] data_in,
    output reg [15:0] data_out
);
    reg [15:0] memory [15:0]; // 16 16-bit SRAM cells

    always @(posedge clk) begin
        if (enable) begin
            if (write) begin
                memory[address] <= data_in; // Write data
            end
            data_out <= memory[address]; // Read data
        end
    end
endmodule