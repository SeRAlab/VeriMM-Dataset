module dram_cell (
    input wire [7:0] data_in,
    input wire word_select,
    input wire write_enable,
    output reg [7:0] data_out
);

reg [7:0] memory;

always @(posedge word_select or posedge write_enable) begin
    if (write_enable) begin
        memory <= data_in; // Write data to memory
    end
end

always @(posedge word_select) begin
    data_out <= memory; // Read data from memory
end

endmodule