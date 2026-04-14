module sram_cell (
    input wire clk,
    input wire enable,
    input wire write_enable,
    input wire [3:0] address,
    input wire [15:0] data_in,
    output reg [15:0] data_out
);
    reg [15:0] memory [0:15]; // 16x16-bit memory

    always @(posedge clk) begin
        if (enable) begin
            if (write_enable) begin
                memory[address] <= data_in; // Write data to memory
            end else begin
                data_out <= memory[address]; // Read data from memory
            end
        end
    end
endmodule