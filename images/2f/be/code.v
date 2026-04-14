module SRAM (
    input clk,
    input we,
    input [3:0] addr,
    input [15:0] data_in,
    output reg [15:0] data_out
);
    reg [15:0] memory [0:15]; // 16 cells of 16 bits each

    always @(posedge clk) begin
        if (we) begin
            memory[addr] <= data_in; // Write data to the selected address
        end
        data_out <= memory[addr]; // Always read data from the selected address
    end
endmodule