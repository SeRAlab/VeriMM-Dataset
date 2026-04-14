module dram_cell (
    input wire clk,
    input wire write_enable,
    input wire [2:0] addr,
    input wire data_in,
    output reg data_out
);
    reg [7:0] memory; // 8-bit memory cells

    always @(posedge clk) begin
        if (write_enable) begin
            memory[addr] <= data_in; // Write data to the selected address
        end
        data_out <= memory[addr]; // Read data from the selected address
    end
endmodule