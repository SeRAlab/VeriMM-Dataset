module flash_memory_cell (
    input wire clk,
    input wire write_enable,
    input wire data_in,
    input wire read_enable,
    output reg data_out
);
    reg stored_bit;

    always @(posedge clk) begin
        if (write_enable) begin
            stored_bit <= data_in; // Write data to the cell
        end
        if (read_enable) begin
            data_out <= stored_bit; // Read data from the cell
        end
    end
endmodule