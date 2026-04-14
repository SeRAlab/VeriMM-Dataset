module dram_cell (
    input wire wr,
    input wire [2:0] addr,
    input wire [3:0] data_in,
    input wire clk,
    output reg [3:0] data_out
);
    reg [3:0] memory [0:7]; // 8 x 4-bit memory cells

    always @(posedge clk) begin
        if (wr) begin
            memory[addr] <= data_in; // Write data to address
        end
        data_out <= memory[addr]; // Read data from address
    end
endmodule