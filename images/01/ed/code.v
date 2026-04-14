module sram_8bit (
    input [7:0] data_in,
    input [2:0] addr,
    input we,
    input clk,
    output reg [7:0] data_out
);
    reg [7:0] memory [7:0]; // 8-bit data, 8 addresses

    always @(posedge clk) begin
        if (we) begin
            memory[addr] <= data_in; // Write operation
        end
        data_out <= memory[addr]; // Read operation
    end
endmodule