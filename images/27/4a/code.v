module flash_memory (
    input clk,
    input write_enable,
    input data_in,
    output reg data_out
);
    reg memory_cell; // 1-bit memory cell

    always @(posedge clk) begin
        if (write_enable) begin
            memory_cell <= data_in; // Write data to memory cell
        end
        data_out <= memory_cell; // Read data from memory cell
    end
endmodule