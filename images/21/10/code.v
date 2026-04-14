module FlashMemoryCell (
    input wire clk,
    input wire write_en,
    input wire read_en,
    input wire erase_en,
    input wire data_in,
    output reg data_out
);
    always @(posedge clk) begin
        if (erase_en) begin
            data_out <= 0; // Erase the memory cell
        end else if (write_en) begin
            data_out <= data_in; // Write data to the memory cell
        end // Read operation is just outputting the current stored value
    end
endmodule