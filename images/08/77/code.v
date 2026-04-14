module FlashMemoryCell (
    input clk,
    input write_enable,
    input erase_enable,
    input [7:0] data_in,
    input read_enable,
    output reg [7:0] data_out
);

reg [7:0] memory_cell;

always @(posedge clk) begin
    if (erase_enable) begin
        memory_cell <= 8'b00000000; // Erase operation
    end else if (write_enable) begin
        memory_cell <= data_in; // Write operation
    end
end

always @(posedge clk) begin
    if (read_enable) begin
        data_out <= memory_cell; // Read operation
    end
end

endmodule