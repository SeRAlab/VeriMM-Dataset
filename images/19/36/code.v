module sram_cell (
    input clk,
    input [3:0] addr,
    input [15:0] data_in,
    input we,  // write enable
    output reg [15:0] data_out
);
    reg [15:0] memory [0:15]; // 16 memory cells, each 16-bit wide

    always @(posedge clk) begin
        if (we) begin
            memory[addr] <= data_in; // Write data
        end
        else begin
            data_out <= memory[addr]; // Read data
        end
    end
endmodule