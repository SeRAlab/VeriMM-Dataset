module dram_cell (
    input  wire [7:0] data_in,
    input  wire [2:0] addr,
    input  wire wr_en,
    input  wire clk,
    output reg  [7:0] data_out
);
    reg [7:0] memory [0:7]; // 8 locations of 8 bits each

    always @(posedge clk) begin
        if (wr_en) begin
            memory[addr] <= data_in; // Write data to memory
        end else begin
            data_out <= memory[addr]; // Read data from memory
        end
    end
endmodule