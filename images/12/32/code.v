module dram_cell (
    input wire [7:0] data_in,
    input wire word_line,
    input wire bit_line,
    output reg [7:0] data_out
);

reg [7:0] memory;

always @(posedge word_line) begin
    memory <= data_in;  // Write operation
end

always @(posedge bit_line) begin
    data_out <= memory;  // Read operation
end

endmodule