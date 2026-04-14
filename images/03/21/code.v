module DRAM_Cell (
    input wire clk,
    input wire we,
    input wire [7:0] data_in,
    input wire [2:0] addr,
    output reg [7:0] data_out
);
    reg [7:0] memory [0:7]; // 8x8-bit memory

    always @(posedge clk) begin
        if (we) begin
            memory[addr] <= data_in; // Write operation
        end
        data_out <= memory[addr]; // Read operation
    end
endmodule