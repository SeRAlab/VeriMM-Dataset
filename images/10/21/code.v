module EEPROM_Cell(
    input wire data_in,
    input wire write_enable,
    input wire read_enable,
    output reg data_out
);

    always @(posedge write_enable) begin
        if (write_enable) begin
            data_out <= data_in;
        end
    end

    always @(posedge read_enable) begin
        if (read_enable) begin
            // Maintain the data_out value
            data_out <= data_out; // This line is not necessary but clarifies intent
        end
    end

endmodule