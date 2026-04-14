module sram_cell (
    input wire clk,
    input wire we,
    input wire [15:0] addr,
    input wire [15:0] data_in,
    output reg [15:0] data_out
);
    reg [15:0] memory [0:65535]; // 64K x 16-bit Memory

    always @(posedge clk) begin
        if (we) begin
            memory[addr] <= data_in; // Write data to memory
        end
        data_out <= memory[addr]; // Read data from memory
    end
endmodule