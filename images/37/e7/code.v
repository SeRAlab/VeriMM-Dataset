module dram_cell (
    input wire clk,
    input wire wr_en,
    input wire [3:0] data_in,
    input wire [1:0] addr,
    output reg [3:0] data_out
);
    reg [3:0] memory [0:3]; // 4 memory locations of 4 bits each

    always @(posedge clk) begin
        if (wr_en) begin
            memory[addr] <= data_in; // Write data to memory
        end
        data_out <= memory[addr]; // Read data from memory
    end
endmodule