module sram_16bit (
    input wire [3:0] address,
    input wire [15:0] data_in,
    input wire write_enable,
    input wire clk,
    output reg [15:0] data_out
);
    reg [15:0] memory [0:15]; // 16 memory locations of 16 bits each

    always @(posedge clk) begin
        if (write_enable) begin
            memory[address] <= data_in; // Write data to memory
        end
        data_out <= memory[address]; // Read data from memory
    end
endmodule