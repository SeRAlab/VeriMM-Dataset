module dram_cell (
    input wire data_in,
    input wire write_enable,
    input wire read_enable,
    output reg data_out
);

reg stored_bit;  // Internal storage for the DRAM cell

always @(posedge write_enable) begin
    stored_bit <= data_in; // Write data to the cell on write enable
end

always @(posedge read_enable) begin
    data_out <= stored_bit; // Read data from the cell on read enable
end

endmodule