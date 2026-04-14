module SRAM_4bit (
    input wire [3:0] data_in,
    input wire [1:0] address,
    input wire write_enable,
    input wire clock,
    output reg [3:0] data_out
);
    reg [3:0] memory [0:3]; // 4 x 4-bit memory

    always @(posedge clock) begin
        if (write_enable) begin
            memory[address] <= data_in; // Write data to selected address
        end
        data_out <= memory[address]; // Read data from selected address
    end
endmodule