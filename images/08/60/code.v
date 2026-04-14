module eeprom_cell (
    input wire write_enable,
    input wire read_enable,
    input wire data_in,
    output reg data_out
);

    always @(*) begin
        if (write_enable) begin
            data_out <= data_in; // Store data when writing
        end else if (read_enable) begin
            // Output the stored data when reading
            data_out <= data_out; // Maintain current value
        end
    end

endmodule