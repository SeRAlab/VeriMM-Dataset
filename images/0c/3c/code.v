module dram_cell (
    input wire data_in,
    input wire word_line,
    input wire bit_line,
    output reg data_out
);

reg stored_value;

always @(posedge word_line) begin
    stored_value <= data_in; // Write operation
end

always @(negedge word_line or posedge bit_line) begin
    if (bit_line) begin
        data_out <= stored_value; // Read operation
    end
end

endmodule