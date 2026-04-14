module flash_memory_cell (
    input wire data_in,
    input wire write_enable,
    output reg data_out
);
    always @(*) begin
        if (write_enable) begin
            data_out = data_in; // Write data to memory cell
        end
    end
endmodule