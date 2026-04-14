module dram_cell (
    input wire clk,
    input wire we,
    input wire [2:0] addr,
    input wire data_in,
    output reg data_out
);

    reg [7:0] memory; // 8-bit memory array

    always @(posedge clk) begin
        if (we) begin
            memory[addr] <= data_in; // Write data to memory
        end
        data_out <= memory[addr]; // Read data from memory
    end
endmodule