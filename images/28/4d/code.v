module sram_cell (
    input wire [3:0] addr,
    input wire [15:0] data_in,
    input wire we,
    input wire re,
    output reg [15:0] data_out
);
    reg [15:0] memory [0:15]; // 16x16 SRAM array

    always @(posedge we) begin
        memory[addr] <= data_in; // Write data to SRAM
    end

    always @(posedge re) begin
        data_out <= memory[addr]; // Read data from SRAM
    end
endmodule