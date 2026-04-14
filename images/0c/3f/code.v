module SRAM_4bit (
    input clk,
    input we,
    input [3:0] addr,
    input [3:0] data_in,
    output reg [3:0] data_out
);
    reg [3:0] memory [0:15]; // 16 locations of 4 bits each

    always @(posedge clk) begin
        if (we) begin
            memory[addr] <= data_in; // Write data to memory
        end
        data_out <= memory[addr]; // Read data from memory
    end
endmodule