module sram_cell (
    input wire clk,
    input wire we,
    input wire [2:0] addr,
    input wire [7:0] data_in,
    output reg [7:0] data_out
);
    reg [7:0] memory [0:7];  // 8x8 SRAM memory

    always @(posedge clk) begin
        if (we) begin
            memory[addr] <= data_in;  // Write data to memory
        end
        data_out <= memory[addr];  // Read data from memory
    end
endmodule