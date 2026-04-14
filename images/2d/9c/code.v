module flash_memory_cell (
    input wire data_in,
    input wire write_enable,
    output reg data_out
);
    always @(*) begin
        if (write_enable) begin
            data_out = data_in; // Store the input data when write_enable is high
        end
        // When write_enable is low, data_out retains its previous value
    end
endmodule