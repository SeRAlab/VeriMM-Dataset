module sram_cell (
    input wire [3:0] address,
    input wire [15:0] data_in,
    output reg [15:0] data_out,
    input wire write_enable,
    input wire clk
);

    reg [15:0] memory [0:15]; // 16 x 16-bit SRAM

    always @(posedge clk) begin
        if (write_enable) begin
            memory[address] <= data_in; // Write data
        end
        else begin
            data_out <= memory[address]; // Read data
        end
    end
endmodule