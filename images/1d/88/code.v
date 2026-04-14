module dram_cell (
    input wire clk,
    input wire rst,
    input wire we,       // Write Enable
    input wire re,       // Read Enable
    input wire [15:0] data_in,
    output reg [15:0] data_out
);
    reg [15:0] memory;   // 16-bit memory cell

    always @(posedge clk or posedge rst) begin
        if (rst) begin
            memory <= 16'b0;  // Reset memory
            data_out <= 16'b0; // Clear output on reset
        end else if (we) begin
            memory <= data_in; // Write data to memory
        end else if (re) begin
            data_out <= memory; // Read data from memory
        end
    end
endmodule