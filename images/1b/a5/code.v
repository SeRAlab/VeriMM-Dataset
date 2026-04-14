module SRAM (
    input wire [15:0] data_in,
    output reg [15:0] data_out,
    input wire write_enable,
    input wire [7:0] address,
    input wire clk
);
    reg [15:0] memory [0:255]; // 256x16-bit memory

    always @(posedge clk) begin
        if (write_enable) begin
            memory[address] <= data_in; // Write data to memory
        end else begin
            data_out <= memory[address]; // Read data from memory
        end
    end
endmodule