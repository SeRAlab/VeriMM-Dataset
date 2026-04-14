module sram_cell (
    input [7:0] data_in,
    input write_enable,
    input clk,
    input [2:0] addr,
    output reg [7:0] data_out
);
    reg [7:0] memory [7:0]; // 8-bit x 8 memory

    always @(posedge clk) begin
        if (write_enable) begin
            memory[addr] <= data_in; // Write data
        end
        data_out <= memory[addr]; // Read data
    end
endmodule